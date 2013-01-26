#!/usr/bin/ruby -w
# -*- ruby -*-

require 'asciitable/data'
require 'asciitable/tc'

module ASCIITable
  class DataTest < TestCase
    def test_keys
      dtd = DefaultTableData.new 'name'
      dtd.keys << "alpha"
      dtd.keys << "bravo"
      assert_equal %w{ alpha bravo }, dtd.keys
    end

    def test_values
      dtd = DefaultTableData.new 'name'
      dtd.values["alpha"] = { :old => 'able' }
      dtd.values["bravo"] = { :old => 'baker' }
      assert_equal 'able', dtd.value("alpha", :old)
    end

    def test_leftcol
      dtd = DefaultTableData.new 'name'
      assert_equal 'name', dtd.leftcol
    end
  end
end
