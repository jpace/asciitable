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

      puts "-------------------------------------------------------"
      puts str
      puts "-------------------------------------------------------"

      assert_equal expected.join(''), str
    end
  end
end
