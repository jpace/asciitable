#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubygems'
require 'test/unit'
require 'asciitable/table'
require 'stringio'

module ASCIITable
  class TableTest < Test::Unit::TestCase
    class DogData < DefaultTableData
      def initialize 
        super
        add_dog 'lucky', 'mixed', 'Illinois'
        add_dog 'frisky', 'dachshund', 'Illinois'
        add_dog 'boots', 'beagle', 'Indiana'
        add_dog 'sandy', 'ridgeback', 'Indiana'
        add_dog 'cosmo', 'retriever', 'Virginia'
      end

      def add_dog name, breed, state
        keys << name
        values[name] = { :breed => breed, :state => state }
      end
      
      def fields
        [ :breed, :state ]
      end
    end

    class DogTable < Table
      attr_reader :data
      
      def initialize 
        @data = DogData.new
        super Hash.new
      end

      def headings
        %w{ name } + @data.fields.collect { |x| x.to_s }
      end
    end

    class TestData < DefaultTableData
      def initialize 
        super

        add 'zero', 'cero', 'none'
        add 'one', 'uno', 'single'
        add 'two', 'dos', 'multiple'
      end

      def add num, span, desc
        keys << num
        values[num] = { :spanish => span, :description => desc }
      end
      
      def fields
        [ :spanish, :description ]
      end
    end

    class TestTable < Table
      attr_reader :data
      
      def initialize 
        @data = TestData.new
        super Hash.new
      end

      def headings
        %w{ number } + @data.fields.collect { |x| x.to_s }
      end
    end

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

    def test_default
      expected = [
                  "|     name     |    breed     |    state     |",
                  "| ------------ | ------------ | ------------ |",
                  "| lucky        | mixed        | Illinois     |",
                  "| frisky       | dachshund    | Illinois     |",
                  "| boots        | beagle       | Indiana      |",
                  "| sandy        | ridgeback    | Indiana      |",
                  "| cosmo        | retriever    | Virginia     |",
                 ]

      run_output_test(expected) do
        table = DogTable.new
        table.print
      end
    end

    def test_last_column
      table = DogTable.new
      assert_equal 2, table.last_column
    end

    def test_last_row
      table = DogTable.new
      assert_equal 5, table.last_row
    end

    def test_set_separator_row
      table = TestTable.new
      table.set_separator_row 2
      expected = [
                  "|    number    |   spanish    | description  |",
                  "| ------------ | ------------ | ------------ |",
                  "| zero         | cero         | none         |",
                  "| ------------ | ------------ | ------------ |",
                  "| one          | uno          | single       |",
                  "| two          | dos          | multiple     |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end

    def test_set_column_align_right
      table = TestTable.new
      table.set_column_align 2, :right
      expected = [
                  "|    number    |   spanish    | description  |",
                  "| ------------ | ------------ | ------------ |",
                  "| zero         | cero         |         none |",
                  "| one          | uno          |       single |",
                  "| two          | dos          |     multiple |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end

    def test_set_column_align_center
      table = TestTable.new
      table.set_column_align 1, :center
      expected = [
                  "|    number    |   spanish    | description  |",
                  "| ------------ | ------------ | ------------ |",
                  "| zero         |     cero     | none         |",
                  "| one          |     uno      | single       |",
                  "| two          |     dos      | multiple     |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end

    def test_set_column_width
      table = TestTable.new
      table.set_column_width 2, 11
      expected = [
                  "|    number    |   spanish    | description |",
                  "| ------------ | ------------ | ----------- |",
                  "| zero         | cero         | none        |",
                  "| one          | uno          | single      |",
                  "| two          | dos          | multiple    |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end

    def test_default_table_data_keys
      dtd = DefaultTableData.new
      dtd.keys << "alpha"
      dtd.keys << "bravo"
      assert_equal %w{ alpha bravo }, dtd.keys
    end

    def test_default_table_data_values
      dtd = DefaultTableData.new
      dtd.values["alpha"] = { :old => 'able' }
      dtd.values["bravo"] = { :old => 'baker' }
      assert_equal 'able', dtd.value("alpha", :old)
    end
  end
end
