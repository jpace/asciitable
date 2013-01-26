#!/usr/bin/ruby -w
# -*- ruby -*-

require 'asciitable/table'
require 'asciitable/data'
require 'asciitable/tc'

module ASCIITable
  class TableTest < TestCase
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

    class NumberData < DefaultTableData
      def initialize 
        super 'number', :spanish, :description

        add 'zero', 'cero', 'none'
        add 'one', 'uno', 'single'
        add 'two', 'dos', 'multiple'
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
        table = Table.new DogData.new
        table.print
      end
    end

    def test_last_column
      table = Table.new DogData.new
      assert_equal 2, table.last_column
    end

    def test_last_row
      table = Table.new DogData.new
      assert_equal 5, table.last_row
    end

    def test_set_separator_row
      table = Table.new NumberData.new
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
      table = Table.new NumberData.new
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
      table = Table.new NumberData.new
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
      table = Table.new NumberData.new
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
        super 'type', :first, :second, :third
        add 'odd', [ 'one', '1' ], [ 'three', '3' ], [ 'five', '5' ]
        add 'even', [ 'two', '2' ], [ 'four', '4' ], [ 'six', '6' ]
      end
      
      def value key, field, index
        @values[key][field][index]
      end
    end

    class DecimalTable < Table
      def initialize 
        super DecimalData.new
      end

      def data_cell_span
        2
      end
    end
    
    def test_data_cell_span
      table = DecimalTable.new
      expected = [
                  "|     type     |            first            |           second            |            third            |",
                  "| ------------ | ------------ | ------------ | ------------ | ------------ | ------------ | ------------ |",
                  "| odd          | one          | 1            | three        | 3            | five         | 5            |",
                  "| even         | two          | 2            | four         | 4            | six          | 6            |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end
    
    class UnsetData < DefaultTableData
      def initialize 
        super 'scores', :first, :second, :third
        @keys << 'Indiana'
        inscores = @values['Indiana'] = Hash.new
        inscores[:first] = '104'
        inscores[:third] = '82'

        @keys << 'Illinois'
        ilscores = @values['Illinois'] = Hash.new
        ilscores[:second] = '71'
        ilscores[:third] = '64'
      end
    end
    
    def test_default_value_unset
      table = Table.new UnsetData.new
      expected = [
                  "|    scores    |    first     |    second    |    third     |",
                  "| ------------ | ------------ | ------------ | ------------ |",
                  "| Indiana      | 104          |              | 82           |",
                  "| Illinois     |              | 71           | 64           |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end
    
    def test_default_value_set
      table = Table.new UnsetData.new, { :default_value => 53 }
      expected = [
                  "|    scores    |    first     |    second    |    third     |",
                  "| ------------ | ------------ | ------------ | ------------ |",
                  "| Indiana      | 104          | 53           | 82           |",
                  "| Illinois     | 53           | 71           | 64           |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end
  end
end
