#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubygems'
require 'logue/log'
require 'riel/enumerable'

class Array
  include RIEL::EnumerableExt
end

module ASCIITable
  class Row
    include Logue::Loggable
    
    def print values
      $stdout.puts "| " + values.join(" | ") + " |"
    end
  end

  class BannerRow < Row
    def initialize char, col_widths
      @char = char
      @col_widths = col_widths
    end

    def print
      banner = (0 ... @col_widths.length).collect { |col| BannerCell.new(col, 1, @char) }
      bannervalues = banner.collect_with_index do |bc, colidx| 
        width = @col_widths[colidx]
        bc.formatted_value width, :center
      end
      super bannervalues
    end
  end

  class StatRow < Row
    attr_reader :values
    
    def initialize cells, ndatarows, ncolumns
      @cells = cells

      @values = Array.new
      @values << name
      
      # $$$ this must account for the last column being a stat also, which
      # shouldn't be used.
      1.upto(ncolumns) do |col|
        val = calculate(col, ndatarows)
        @values << val
      end
    end

    def total col, torow
      @cells.cells_in_column(col).inject(0) do |sum, cell|
        val = cell.row >= 1 && cell.row <= torow ? cell.value.to_i : 0
        sum + val
      end
    end
  end

  class TotalRow < StatRow
    def name
      "total"
    end

    def calculate col, torow
      total(col, torow)
    end
  end

  class AverageRow < StatRow
    def name
      "average"
    end
    
    def calculate col, torow
      nrows = torow
      total = total(col, torow)
      total / nrows
    end
  end
end
