#!/usr/bin/ruby -w
# -*- ruby -*-

require 'asciitable/data'
require 'asciitable/tc'

module ASCIITable
  class DataTest < TestCase
    def test_keys
      dtd = DefaultTableData.new
      dtd.keys << "alpha"
      dtd.keys << "bravo"
      assert_equal %w{ alpha bravo }, dtd.keys
    end

    def test_values
      dtd = DefaultTableData.new
      dtd.values["alpha"] = { :old => 'able' }
      dtd.values["bravo"] = { :old => 'baker' }
      assert_equal 'able', dtd.value("alpha", :old)
    end
  end
end
