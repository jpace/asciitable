#!/usr/bin/ruby -w
# -*- ruby -*-

require 'asciitable/table'
require 'asciitable/data'
require 'asciitable/tc'

module ASCIITable
  class TableTest < TestCase
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

    class NumberData < DefaultTableData
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

    class NumberTable < Table
      attr_reader :data
      
      def initialize 
        @data = NumberData.new
        super Hash.new
      end

      def headings
        %w{ number } + @data.fields.collect { |x| x.to_s }
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
      table = NumberTable.new
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
      table = NumberTable.new
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
      table = NumberTable.new
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
      table = NumberTable.new
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

    class DecimalData < DefaultTableData
      def initialize 
        super
        add 'odd', 'one', '1', 'three', '3', 'five', '5'
        add 'even', 'two', '2', 'four', '4', 'six', '6'
      end

      def add num, astr, anum, bstr, bnum, cstr, cnum
        keys << num
        values[num] = { :first => [ astr, anum ], :second => [ bstr, bnum ], :third => [ cstr, cnum ] }
      end
      
      def fields
        [ :first, :second, :third ]
      end

      def value key, field, index
        @values[key][field][index]
      end
    end

    class DecimalTable < Table
      attr_reader :data
      
      def initialize 
        @data = DecimalData.new
        super Hash.new
      end

      def headings
        %w{ name } + @data.fields.collect { |x| x.to_s }
      end

      def data_cell_span
        2
      end
    end
    
    def test_span
      table = DecimalTable.new
      expected = [
                  "|     name     |            first            |           second            |            third            |",
                  "| ------------ | ------------ | ------------ | ------------ | ------------ | ------------ | ------------ |",
                  "| odd          | one          | 1            | three        | 3            | five         | 5            |",
                  "| even         | two          | 2            | four         | 4            | six          | 6            |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end
  end
end
