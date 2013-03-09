#!/usr/bin/ruby -w
# -*- ruby -*-

module ASCIITable
  class Columns
    def initialize default_cell_width, default_align
      @default_cell_width = default_cell_width
      @default_align = default_align
      @columns = Array.new
    end

    def width col
      ((c = @columns[col]) && c.width) || @default_cell_width
    end

    def align col
      ((c = @columns[col]) && c.align) || @default_align
    end

    def [] col
      column = @columns[col]
      unless column
        column = @columns[col] = Column.new(col, @default_cell_width, @default_align)
      end
      column
    end
  end
end
