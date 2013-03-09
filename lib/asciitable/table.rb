#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubygems'
require 'logue/log'
require 'asciitable/cell'
require 'asciitable/column'
require 'asciitable/row'
require 'asciitable/data'
require 'asciitable/separator_rows'
require 'asciitable/cells'
require 'asciitable/columns'

module ASCIITable
  class Table
    include Logue::Loggable

    attr_reader :cells

    def initialize data, args = Hash.new
      align = args[:align] || :left

      cell_options = args[:cell_options] || Hash.new
      
      cellwidth = cell_options[:width] || 12
      default_value = cell_options[:default_value] || ""
      data_cell_span = cell_options[:span] || 1

      @columns = Columns.new(cellwidth, align)
      @separator_rows = SeparatorRows.new
      @cells = Cells.new(Cell, data, data_cell_span, default_value)

      if nsep = args[:separators_every]
        @separator_rows.add_every(@cells.data_rows.last, nsep, '-')
      end
    end

    # sets a separator for the row preceding +rownum+. Does not change the
    # coordinates for any other cells.
    def set_separator_row rownum, char = '-'
      @separator_rows.insert(rownum, char)
    end

    def append_separator_row char = '-'
      @separator_rows.append(@cells.last_row, char)
    end

    def cell col, row
      @cells.cell(col, row)
    end

    def set_column_align col, align
      column(col).align = align
    end

    def set_column_width col, width
      column(col).width = width
    end

    def column col
      @columns[col]
    end

    def set_value col, row, val
      cell(col, row).value = val
    end

    def set_color col, row, *colors
      cell(col, row).colors = colors
    end

    def get_formatted_values rownum, align = nil
      tocol = @cells.last_column
      col = 0
      fmtdvalues = Array.new

      while col <= tocol
        aln = align || @columns.align(col)
        cell = cell(col, rownum)
        width = @columns.width(col)
        fmtdvalues << cell.formatted_value(width, aln)
        if cell.span
          col = cell.span
        end
        col += 1
      end

      fmtdvalues
    end
    
    def print_row row, align = nil
      values = get_formatted_values(row, align)
      Row.new.print(values)
    end

    def print_banner char = '-'
      last_col = @cells.last_column
      col_widths = (0 .. last_col).collect { |col| @columns.width(col) }
      BannerRow.new(char, col_widths).print
    end
    
    def print_header
      # cells in the header are always centered
      print_row 0, :center
      print_banner
    end

    def print
      print_header
      
      (1 .. @cells.last_row).each do |row|
        if char = @separator_rows[row]
          print_banner char
        end
        print_row row
      end
    end
  end
end
