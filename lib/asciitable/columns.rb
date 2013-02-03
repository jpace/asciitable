#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubygems'
require 'riel'

module ASCIITable
  class Columns < Array
    def initialize default_cell_width, default_align
      @default_cell_width = default_cell_width
      @default_align = default_align
      super()
    end

    def width col
      ((c = self[col]) && c.width) || @default_cell_width
    end

    def align col
      ((c = self[col]) && c.align) || @default_align
    end

    def [] col
      column = super
      unless column
        column = self[col] = Column.new(col, @default_cell_width, @default_align)
      end
      column
    end
  end
end
