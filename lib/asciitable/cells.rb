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
  end
end
