#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubygems'
require 'riel/log'
require 'asciitable/cell'
require 'asciitable/column'
require 'asciitable/row'
require 'asciitable/data'

module ASCIITable
  class Cells < Array
  end

  class Table
    include Loggable

    attr_reader :data

    def initialize data, args = Hash.new
      @cells = Cells.new

      @data = data
      
      @cellwidth = args[:cellwidth] || 12
      @align = args[:align] || :left
      @columns = Array.new
      @separator_rows = Hash.new
      @default_value = args[:default_value] || ""
      @data_cell_span = args[:data_cell_span] || 1
      
      set_headings
      set_cells

      if sepival = args[:separators]
        add_separators sepival
      end
      
      if nsep = args[:separators_every]
        add_separators nsep
      end
    end

    # sets a separator for the row preceding +rownum+. Does not change the
    # coordinates for any other cells.
    def set_separator_row rownum, char = '-'
      @separator_rows[rownum] = char
    end

    def add_separator_row char = '-'
      @separator_rows[last_row + 1] = char
    end

    def add_separators nbetween
      # banner every N rows
      drows = data_rows

      drows.first.upto((drows.last - 1) / nbetween) do |num|
        set_separator_row 1 + num * nbetween, '-'
      end
    end

    def last_column
      @cells.collect { |cell| cell.column }.max
    end

    def last_row
      @cells.collect { |cell| cell.row }.max
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

    def cell col, row
      cl = find_cell(col, row)
      unless cl
        cl = Cell.new(col, row, @default_value)
        @cells << cl
      end
      cl
    end

    def set_column_align col, align
      column(col).align = align
    end

    def set_column_width col, width
      column(col).width = width
    end

    def column_width col
      ((c = @columns[col]) && c.width) || @cellwidth
    end

    def column_align col
      ((c = @columns[col]) && c.align) || @align
    end

    def column col
      @columns[col] ||= Column.new(self, col, @cellwidth, @align)
    end

    def set_value col, row, val
      cell(col, row).value = val
    end

    def set_color col, row, *colors
      cell(col, row).colors = colors
    end

    def print_row row, align = nil
      Row.new(self, row).print @columns, align
    end

    def print_banner char = '-'
      last_col = last_column
      col_widths = (0 .. last_col).collect { |col| column_width(col) }
      BannerRow.new(char, col_widths).print
    end
    
    def print_header
      # cells in the header are always centered
      print_row 0, :center
      print_banner
    end

    def print
      print_header
      
      (1 .. last_row).each do |row|
        if char = @separator_rows[row]
          print_banner char
        end
        print_row row
      end
    end

    def set_headings
      cellspan = @data_cell_span

      headings = [ @data.leftcol ] + @data.fields.collect { |x| x.to_s }

      row = 0

      colidx = 0
      headings.each do |heading|
        cl = Cell.new(colidx, row, heading)
        @cells << cl

        # column zero doesn't span:
        if colidx == 0 || cellspan == 1
          colidx += 1
        else
          tocol = colidx - 1 + cellspan
          cl.span = tocol
          colidx += cellspan
        end
      end
    end

    def set_cells
      rownum = 1
      dcs = @data_cell_span
      
      @data.keys.each_with_index do |key, nidx|
        # left column == key name
        cl = Cell.new(0, rownum, key)
        @cells << cl

        colidx = 1
        @data.fields.each do |field|
          (0 .. (dcs - 1)).each do |didx|
            val = @data.value(key, field, didx) || @default_value
            cl = Cell.new(colidx, rownum, val)
            @cells << cl
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
      (1 .. @data.fields.length * @data_cell_span)
    end
  end
end
