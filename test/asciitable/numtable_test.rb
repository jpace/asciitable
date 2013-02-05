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
    
    def test_highlight_max_cells_in_row
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
  end
end
