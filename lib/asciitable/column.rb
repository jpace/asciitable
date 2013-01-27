#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubygems'
require 'riel/log'

module ASCIITable
  class Column
    attr_accessor :num
    attr_accessor :width
    attr_accessor :align

    def initialize num, width = nil, align = nil
      @num = num
      @width = width
      @align = align
    end
  end
end
