#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubygems'
require 'test/unit'
require 'stringio'
require 'asciitable/data'
require 'asciitable/tc'

Sickill::Rainbow.enabled = true

module ASCIITable
  class TestCase < Test::Unit::TestCase
    def run_output_test(expected, &blk)
      origout = $stdout
      sio = StringIO.new
      $stdout = sio
      
      blk.call

      sio.flush
      str = sio.string
      $stdout = origout

      puts "......................................................."
      puts str
      puts "......................................................."
      
      result = str.split "\n"

      (0 ... [ expected.size, result.size ].max).each do |idx|
        assert_equal expected[idx], result[idx], "idx: #{idx}"
      end
    end

    class DogData < DefaultTableData
      def initialize 
        super 'name', :breed, :state
        add 'lucky', 'mixed', 'Illinois'
        add 'frisky', 'dachshund', 'Illinois'
        add 'boots', 'beagle', 'Indiana'
        add 'sandy', 'ridgeback', 'Indiana'
        add 'cosmo', 'retriever', 'Virginia'
      end
    end

    class EngSpanNumData < DefaultTableData
      def initialize 
        super 'number', :spanish, :description

        add 'zero', 'cero', 'none'
        add 'one', 'uno', 'single'
        add 'two', 'dos', 'multiple'
      end
    end

    class NumericData < DefaultTableData
      def initialize 
        super 'type', :first, :second, :third
        add 'odd', 1, 2, 3
        add 'even', 2, 4, 6
      end
    end   

    class LongData < DefaultTableData
      def initialize 
        super 'number', :value
        %w{ zero one two three four five six seven eight }.each_with_index do |number, idx|
          add(number, idx)
        end
      end
    end

    class DecimalData < DefaultTableData
      def initialize 
        super 'type', :first, :second, :third
        add 'odd', [ 'one', '1' ], [ 'three', '3' ], [ 'five', '5' ]
        add 'even', [ 'two', '2' ], [ 'four', '4' ], [ 'six', '6' ]
      end
      
      def value key, field, index
        @values[key][field][index]
      end
    end

    class UnsetData < DefaultTableData
      def initialize 
        super 'scores', :first, :second, :third
        @keys << 'Indiana'
        inscores = @values['Indiana'] = Hash.new
        inscores[:first] =  '104'
        inscores[:third] = '82'

        @keys << 'Illinois'
        ilscores = @values['Illinois'] = Hash.new
        ilscores[:second] = '71'
        ilscores[:third] = '64'
      end
    end    
    
    def test_nothing
    end
  end
end
