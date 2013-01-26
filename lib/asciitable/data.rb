#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubygems'
require 'riel'

module ASCIITable
  class TableData
    def keys
    end

    def fields
    end
    
    def value key, field, index = 0
    end
  end

  class DefaultTableData
    attr_reader :keys
    attr_reader :values
    attr_reader :fields
    attr_reader :leftcol

    def initialize leftcol, *fields
      @keys = Array.new
      @values = Hash.new
      @fields = fields
      @leftcol = leftcol
    end
    
    def value key, field, index = 0
      @values[key][field]
    end

    def add leftcol, *values
      @keys << leftcol
      @values[leftcol] = Hash.new
      flds = @fields
      (0 ... flds.length).each do |idx|
        val = values[idx]
        field = flds[idx]
        @values[leftcol][field] = val
      end
    end
  end
end
