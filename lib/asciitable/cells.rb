#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubygems'
require 'riel'

module ASCIITable
  class Cells
    attr_reader :data_cell_span
    
    def initialize cellcls, data, data_cell_span = 1, default_value = ""
      @cellcls = cellcls
      @data = data
      @data_cell_span = data_cell_span
      @default_value = default_value

      @cells = Array.new

      set_headings
      set_from_data
    end

    def add col, row, value
      cl = @cellcls.new(col, row, value)
      @cells << cl
      cl
    end

    def last_column
      @cells.map(&:column).max
    end

    def last_row
      @cells.map(&:row).max
    end

    def cells_in_column col
      @cells.select { |cell| cell.column == col }
    end

    def cells_in_row row
      @cells.select { |cell| cell.row == row }
    end

    def find_cell col, row
      @cells.detect { |c| c.column == col && c.row == row }
    end

    def cell col, row, value = @default_value
      find_cell(col, row) || add(col, row, value)
    end

    def set_headings
      headings = [ @data.leftcol ] + @data.fields.collect { |x| x.to_s }

      row = 0

      colidx = 0
      headings.each do |heading|
        cl = add(colidx, row, heading)

        # column zero doesn't span:
        if colidx == 0 || @data_cell_span == 1
          colidx += 1
        else
          tocol = colidx - 1 + @data_cell_span
          cl.span = tocol
          colidx += @data_cell_span
        end
      end
    end

    def set_from_data
      rownum = 1
      
      @data.keys.each_with_index do |key, nidx|
        # left column == key name
        add(0, rownum, key)
        
        colidx = 1
        @data.fields.each do |field|
          (0 .. (@data_cell_span - 1)).each do |didx|
            val = @data.value(key, field, didx) || @default_value
            add(colidx, rownum, val)
            colidx += 1
          end
        end
        rownum += 1
      end
    end

    def data_rows
      (1 .. @data.keys.length)
    end

    def data_columns
      (1 .. max_data_column)
    end

    def max_data_column
      @data.fields.length * @data_cell_span
    end

    # returns the cells up to the given column
    def cells_for_row row, offset, maxcol = max_data_column
      cells = cells_in_row row
      cells = cells[1 .. maxcol]
      cells.select_with_index { |cell, cidx| (cidx % @data_cell_span) == offset }
    end
  end
end
