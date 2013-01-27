#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubygems'
require 'riel/log'

module ASCIITable
  class Column
    attr_accessor :width
    attr_accessor :num
    attr_accessor :align
    attr_accessor :table

    def initialize table, num, width = nil, align = nil
      @table = table
      @num = num
      @width = width
      @align = align
    end

    def total fromrow, torow
      @table.cells.cells_in_column(@num).inject(0) do |sum, cell|
        val = cell.row >= fromrow && cell.row <= torow ? cell.value.to_i : 0
        sum + val
      end
    end
  end
end
