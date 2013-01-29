#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubygems'
require 'riel/log'
require 'rainbow'

module ASCIITable
  class Cell
    include Loggable
    
    attr_reader :column
    attr_reader :row

    attr_accessor :value
    attr_accessor :span

    attr_accessor :colors

    def initialize column, row, value = nil, *colors
      @column = column
      @row = row
      @value = value
      @span = span
      @colors = colors
    end

    def _value width
      value.nil? ? nil : value.to_s
    end

    def inspect
      "(#{@column}, #{@row}) => #{@value}"
    end

    def to_s
      "(#{@column}, #{@row}) => #{@value}"
    end

    def formatted_value width, align
      strval = _value width

      if @span
        ncolumns = @span - @column
        width = width * (1 + ncolumns) + (3 * ncolumns)
      end

      diff = width - strval.length
        
      lhs, rhs = case align
                 when :left
                   [ 0, diff ]
                 when :right
                   [ diff, 0 ]
                 when :center
                   l = diff / 2
                   r = diff - l
                   [ l, r ]
                 else
                   raise "alignment '#{align}' not handled; valid alignments: :left, :right, :center"
                 end

      str = (" " * lhs) + strval + (" " * rhs)

      @colors.each do |cl|
        str = str.color cl
      end
      
      str
    end
  end

  class BannerCell < Cell
    def initialize col, row, char
      @char = char
      super(col, row)
    end

    def _value width
      @char * width
    end
  end  
end
