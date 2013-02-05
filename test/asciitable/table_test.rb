#!/usr/bin/ruby -w
# -*- ruby -*-

require 'asciitable/tc'

module ASCIITable
  class TableTest < TestCase
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
      assert_equal 2, table.cells.last_column
    end

    def test_last_row
      table = Table.new DogData.new
      assert_equal 5, table.cells.last_row
    end

    def test_set_separator_row_default
      table = Table.new EngSpanNumData.new
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

    def test_set_separator_row_specified
      table = Table.new EngSpanNumData.new
      table.set_separator_row 2, '*'
      expected = [
                  "|    number    |   spanish    | description  |",
                  "| ------------ | ------------ | ------------ |",
                  "| zero         | cero         | none         |",
                  "| ************ | ************ | ************ |",
                  "| one          | uno          | single       |",
                  "| two          | dos          | multiple     |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end

    def test_set_column_align_right
      table = Table.new EngSpanNumData.new
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
      table = Table.new EngSpanNumData.new
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

    def test_set_cell_align
      table = Table.new EngSpanNumData.new, { :align => :right }
      expected = [
                  "|    number    |   spanish    | description  |",
                  "| ------------ | ------------ | ------------ |",
                  "|         zero |         cero |         none |",
                  "|          one |          uno |       single |",
                  "|          two |          dos |     multiple |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end

    def test_set_column_width
      table = Table.new EngSpanNumData.new
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

    def test_set_cell_width
      table = Table.new EngSpanNumData.new, { :cell_options => { :width => 16 } }
      expected = [
                  "|      number      |     spanish      |   description    |",
                  "| ---------------- | ---------------- | ---------------- |",
                  "| zero             | cero             | none             |",
                  "| one              | uno              | single           |",
                  "| two              | dos              | multiple         |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end
    
    def test_cell_to_s
      table = Table.new NumericData.new
      expected = [
                  "|     type     |    first     |    second    |    third     |",
                  "| ------------ | ------------ | ------------ | ------------ |",
                  "| odd          | 1            | 2            | 3            |",
                  "| even         | 2            | 4            | 6            |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end
    
    def test_data_cell_span
      table = Table.new DecimalData.new, { :cell_options => { :span => 2 } }
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
      table = Table.new UnsetData.new, { :cell_options => { :default_value => '53' } }
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

    def test_add_separators
      table = Table.new LongData.new, { :separators_every => 3 }
      expected = [
                  "|    number    |    value     |",
                  "| ------------ | ------------ |",
                  "| zero         | 0            |",
                  "| one          | 1            |",
                  "| two          | 2            |",
                  "| ------------ | ------------ |",
                  "| three        | 3            |",
                  "| four         | 4            |",
                  "| five         | 5            |",
                  "| ------------ | ------------ |",
                  "| six          | 6            |",
                  "| seven        | 7            |",
                  "| eight        | 8            |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end

    def test_set_color
      table = Table.new UnsetData.new
      table.set_color 3, 1, :red
      table.set_color 3, 2, "ff7f00"
      expected = [
                  "|    scores    |    first     |    second    |    third     |",
                  "| ------------ | ------------ | ------------ | ------------ |",
                  "| Indiana      | 104          |              | [31m82          [0m |",
                  "| Illinois     |              | 71           | [38;5;208m64          [0m |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end

    def test_set_background_color
      table = Table.new UnsetData.new
      table.set_color 3, 1, :on_red
      table.set_color 3, 2, "on_ff7f00"
      expected = [
                  "|    scores    |    first     |    second    |    third     |",
                  "| ------------ | ------------ | ------------ | ------------ |",
                  "| Indiana      | 104          |              | [41m82          [0m |",
                  "| Illinois     |              | 71           | [48;5;208m64          [0m |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end

    def test_set_background_foreground_colors
      table = Table.new UnsetData.new
      table.set_color 3, 1, :red, :on_white
      table.set_color 3, 2, "ff7f00", :on_black
      expected = [
                  "|    scores    |    first     |    second    |    third     |",
                  "| ------------ | ------------ | ------------ | ------------ |",
                  "| Indiana      | 104          |              | [31m[47m82          [0m |",
                  "| Illinois     |              | 71           | [38;5;208m[40m64          [0m |",
                 ]

      run_output_test(expected) do
        table.print
      end
    end
  end
end
