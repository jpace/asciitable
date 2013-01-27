#!/usr/bin/ruby -w
# -*- ruby -*-

require 'asciitable/cell'
require 'asciitable/tc'

module ASCIITable
  class CellTest < Test::Unit::TestCase

    def setup
      @cell = Cell.new 3, 7, "val"
    end

    def test_formatted_value_left
      assert_equal "val     ", @cell.formatted_value(8, :left)
    end

    def test_formatted_value_right
      assert_equal "     val", @cell.formatted_value(8, :right)
    end

    def test_formatted_value_center
      assert_equal "  val   ", @cell.formatted_value(8, :center)
    end

    def test_formatted_value_left_color
      cell = Cell.new 3, 7, "val", :blue
      assert_equal "\e[34mval     \e[0m", cell.formatted_value(8, :left)
    end

    def test_formatted_value_span
      cell = Cell.new 3, 7, "val"
      cell.span = 4
      assert_equal "val                ", cell.formatted_value(8, :left)
    end

    def test_invalid_align
      assert_raises RuntimeError do
        assert_equal "  val   ", @cell.formatted_value(8, :derecha)
      end
    end

    def test_banner_cell
      bc = BannerCell.new 8, 11, "-"
      assert_equal "------------", bc.formatted_value(12, :center)
    end
  end
end
