#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubygems'
require 'riel'

module ASCIITable
  class Cells < Array
    def initialize cellcls, data
      @cellcls = cellcls
      @data = data

      super()
    end

    def add col, row, value
      cl = @cellcls.new(col, row, value)
      self << cl
      cl
    end

    def last_column
      collect { |cell| cell.column }.max
    end

    def last_row
      collect { |cell| cell.row }.max
    end

    def cells_in_column col
      select { |cell| cell.column == col }
    end

    def cells_in_row row
      select { |cell| cell.row == row }
    end

    def find_cell col, row
      detect { |c| c.column == col && c.row == row }
    end

    def cell col, row, value
      find_cell(col, row) || add(col, row, value)
    end

    def set_headings data_cell_span
      headings = [ @data.leftcol ] + @data.fields.collect { |x| x.to_s }

      row = 0

      colidx = 0
      headings.each do |heading|
        cl = add(colidx, row, heading)

        # column zero doesn't span:
        if colidx == 0 || data_cell_span == 1
          colidx += 1
        else
          tocol = colidx - 1 + data_cell_span
          cl.span = tocol
          colidx += data_cell_span
        end
      end
    end

    def set_from_data data_cell_span, default_value
      rownum = 1
      
      @data.keys.each_with_index do |key, nidx|
        # left column == key name
        add(0, rownum, key)
        
        colidx = 1
        @data.fields.each do |field|
          (0 .. (data_cell_span - 1)).each do |didx|
            val = @data.value(key, field, didx) || default_value
            add(colidx, rownum, val)
            colidx += 1
          end
        end
        rownum += 1
      end
    end
  end
end
