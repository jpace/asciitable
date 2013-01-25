#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubygems'
require 'test/unit'
require 'stringio'

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

    def test_nothing
    end
  end
end
