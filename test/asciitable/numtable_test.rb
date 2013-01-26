#!/usr/bin/ruby -w
# -*- ruby -*-

require 'asciitable/numtable'
require 'asciitable/data'
require 'asciitable/tc'

module ASCIITable
  class NumericTableTest < TestCase
    class LongData < DefaultTableData
      def initialize 
        super 'number', :value
        %w{ zero one two three four five six seven eight }.each_with_index do |number, idx|
          add number, idx
        end
      end
    end
    
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
  end
end
