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
    def initialize data
      @data = data
      super()
    end

    def add col, row, value
      cl = Cell.new(col, row, value)
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
  end

  class SeparatorRows < Hash
    # sets a separator for the row preceding +rownum+. Does not change the
    # coordinates for any other cells.
    def insert rownum, char = '-'
      self[rownum] = char
    end

    def append nrows, char = '-'
      self[nrows + 1] = char
    end

    # banner every +nbetween+ rows
    def add_every nrows, nbetween, char = '-'
      1.upto((nrows - 1) / nbetween) do |num|
        insert(1 + num * nbetween, '-')
      end
    end
  end

  class Table
    include Loggable

    attr_reader :data
    attr_reader :cells

    def initialize data, args = Hash.new
      @cells = Cells.new data

      @data = data
      
      @cellwidth = args[:cellwidth] || 12
      @align = args[:align] || :left
      @columns = Array.new
      @separator_rows = SeparatorRows.new
      @default_value = args[:default_value] || ""
      @data_cell_span = args[:data_cell_span] || 1
      
      set_headings
      set_cells

      if nsep = args[:separators_every]
        @separator_rows.add_every(data_rows.last, nsep, '-')
      end
    end

    # sets a separator for the row preceding +rownum+. Does not change the
    # coordinates for any other cells.
    def set_separator_row rownum, char = '-'
      @separator_rows.insert(rownum, char)
    end

    def add_separator_row char = '-'
      @separator_rows.append(@cells.last_row, char)
    end

    def cell col, row
      @cells.cell(col, row, @default_value)
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
      @columns[col] ||= Column.new(col, @cellwidth, @align)
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
        aln = align || column_align(col)
        cell = cell(col, rownum)
        width = column_width col
        fmtdvalues << cell.formatted_value(width, aln)
        if cell.span
          col += (cell.span - col)
        end
        col += 1
      end
      fmtdvalues
    end
    
    def print_row row, align = nil
      Row.new.print_cells get_formatted_values(row, align)
    end

    def print_banner char = '-'
      last_col = @cells.last_column
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
      
      (1 .. @cells.last_row).each do |row|
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
        cl = @cells.add(colidx, row, heading)

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
        @cells.add(0, rownum, key)
        
        colidx = 1
        @data.fields.each do |field|
          (0 .. (dcs - 1)).each do |didx|
            val = @data.value(key, field, didx) || @default_value
            @cells.add(colidx, rownum, val)
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
