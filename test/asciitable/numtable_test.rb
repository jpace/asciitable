#!/usr/bin/ruby -w
# -*- ruby -*-

require 'asciitable/numtable'
require 'asciitable/tc'

Sickill::Rainbow.enabled = true

module ASCIITable
  class NumericTableTest < TestCase
    def test_total_row
      table = NumericTable.new LongData.new, { :has_total_row => true }
      expected = [
                  "|    number    |    value     |",
                  "| ------------ | ------------ |",
                  "| zero         | 0            |",
                  "| one          | 1            |",
                  "| two          | 2            |",
                  "| three        | 3            |",
                  "| four         | 4            |",
                  "| five         | 5            |",
                  "| six          | 6            |",
                  "| seven        | 7            |",
                  "| eight        | 8            |",
                  "| ============ | ============ |",
                  "| total        | 36           |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end
    
    def test_average_row
      table = NumericTable.new LongData.new, { :has_average_row => true }
      expected = [
                  "|    number    |    value     |",
                  "| ------------ | ------------ |",
                  "| zero         | 0            |",
                  "| one          | 1            |",
                  "| two          | 2            |",
                  "| three        | 3            |",
                  "| four         | 4            |",
                  "| five         | 5            |",
                  "| six          | 6            |",
                  "| seven        | 7            |",
                  "| eight        | 8            |",
                  "| ============ | ============ |",
                  "| average      | 4            |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end
    
    def test_total_and_average_row
      table = NumericTable.new LongData.new, { :has_total_row => true, :has_average_row => true }
      expected = [
                  "|    number    |    value     |",
                  "| ------------ | ------------ |",
                  "| zero         | 0            |",
                  "| one          | 1            |",
                  "| two          | 2            |",
                  "| three        | 3            |",
                  "| four         | 4            |",
                  "| five         | 5            |",
                  "| six          | 6            |",
                  "| seven        | 7            |",
                  "| eight        | 8            |",
                  "| ============ | ============ |",
                  "| total        | 36           |",
                  "| average      | 4            |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end

    class SortedNumberData < DefaultTableData
      def initialize 
        super 'number', :value
        numbers = %w{ zero one two three four five six seven eight }.collect_with_index { |num, idx| [ num, idx ] }
        hash = Hash[ [ *numbers ] ]
        hash.sort.each do |num, idx|
          add(num, idx)
        end
      end
    end
    
    def test_highlight_max_cells_in_columns
      table = NumericTable.new SortedNumberData.new, { :highlight_max_cells_in_columns => true, :highlight_colors => [ :red, :cyan, :magenta ] }
      
      expected = [
                  "|    number    |    value     |",
                  "| ------------ | ------------ |",
                  "| eight        | [31m8           [0m |",
                  "| five         | 5            |",
                  "| four         | 4            |",
                  "| one          | 1            |",
                  "| seven        | [36m7           [0m |",
                  "| six          | [35m6           [0m |",
                  "| three        | 3            |",
                  "| two          | 2            |",
                  "| zero         | 0            |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end

    class WideNumberData < DefaultTableData
      def initialize 
        super 'type', :first, :second, :third, :fourth
        add :odd, 11, 17, 3, 7
        add :even, 8, 4, 6, 12
      end
    end
    
    def test_highlight_max_cells_in_row_no_total_column
      table = NumericTable.new WideNumberData.new, { :highlight_max_cells_in_rows => true, :highlight_colors => [ :red, :cyan, :magenta ] }
      
      expected = [
                  "|     type     |    first     |    second    |    third     |    fourth    |",
                  "| ------------ | ------------ | ------------ | ------------ | ------------ |",
                  "| odd          | [36m11          [0m | [31m17          [0m | 3            | [35m7           [0m |",
                  "| even         | [36m8           [0m | 4            | [35m6           [0m | [31m12          [0m |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end

    def test_total_column_no_span
      table = NumericTable.new WideNumberData.new, { :has_total_columns => true }
      
      expected = [
                  "|     type     |    first     |    second    |    third     |    fourth    |    total     |",
                  "| ------------ | ------------ | ------------ | ------------ | ------------ | ------------ |",
                  "| odd          | 11           | 17           | 3            | 7            | 38           |",
                  "| even         | 8            | 4            | 6            | 12           | 30           |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end

    class NumberPairData < DefaultTableData
      def initialize 
        super 'type', :first, :second, :third
        add 'odd', [ 11, 0.2 ], [ 3, 1.3 ], [ 23, 1.4 ]
        add 'even', [ 14, 2.0 ], [ 8, 1.1 ], [ 22, 0.4 ]
      end
      
      def value key, field, index
        @values[key][field][index]
      end
    end

    def test_total_column_cell_span
      table = NumericTable.new NumberPairData.new, { :has_total_columns => true, :cell_options => { :span => 2  } }

      expected = [
                  "|     type     |            first            |           second            |            third            |            total            |",
                  "| ------------ | ------------ | ------------ | ------------ | ------------ | ------------ | ------------ | ------------ | ------------ |",
                  "| odd          | 11           | 0.2          | 3            | 1.3          | 23           | 1.4          | 37           | 2.9          |",
                  "| even         | 14           | 2.0          | 8            | 1.1          | 22           | 0.4          | 44           | 3.5          |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end

    def test_highlight_max_cells_in_row_with_total_columns
      options = Hash.new
      options[:has_total_columns] = true
      options[:highlight_max_cells_in_rows] = true
      options[:cell_options] = { :span => 2  }
      options[:highlight_colors] = [ :red, :yellow ]
      table = NumericTable.new NumberPairData.new, options

      expected = [
                  "|     type     |            first            |           second            |            third            |            total            |",
                  "| ------------ | ------------ | ------------ | ------------ | ------------ | ------------ | ------------ | ------------ | ------------ |",
                  "| odd          | [33m11          [0m | 0.2          | 3            | [33m1.3         [0m | [31m23          [0m | [31m1.4         [0m | 37           | 2.9          |",
                  "| even         | [33m14          [0m | [31m2.0         [0m | 8            | [33m1.1         [0m | [31m22          [0m | 0.4          | 44           | 3.5          |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end
  end
end
