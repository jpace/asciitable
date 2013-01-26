#!/usr/bin/ruby -w
# -*- ruby -*-

require 'asciitable/table'

module ASCIITable
  class NumericTable < Table
    def initialize data, args = Hash.new
      super
      totrow = args[:has_total_row]
      avgrow = args[:has_average_row]

      if totrow || avgrow
        add_separator_row '='
        if totrow
          TotalRow.new(self)
        end
        
        if avgrow
          AverageRow.new(self)
        end
      end
      
      if args[:has_total_columns]
        add_total_columns
      end
      
      if args[:highlight_max_cells]
        highlight_max_cells
      end
    end

    # returns the values in cells, sorted and unique
    def sort_values cells
      cells.collect { |cell| cell.value }.uniq.sort.reverse
    end

    def data_cells_for_row row, offset
      cells_for_row row, offset, @data.fields.length * @data_cell_span
    end

    def get_highlight_colors 
      Array.new
    end

    def highlight_cells_in_row row, offset
      cells = data_cells_for_row row, offset
      highlight_cells cells
    end

    def highlight_cells cells
      vals = sort_values cells

      colors = get_highlight_colors
      
      cells.each do |cell|
        idx = vals.index cell.value
        if cols = colors[idx]
          cell.colors = cols
        end
      end
    end

    def highlight_cells_in_column col
      cells = cells_in_column(col)[data_rows.first .. data_rows.last]
      highlight_cells cells
    end

    def highlight_max_cells
      (1 .. last_row).each do |row|
        (0 .. (@data_cell_span - 1)).each do |offset|
          highlight_cells_in_row row, offset
        end
      end

      0.upto(1) do |n|
        highlight_cells_in_column data_columns.last + n
      end
    end
    
    def add_total_columns
      last_data_col = data_columns.last
      totcol = last_data_col + 1

      (1 .. last_row).each do |row|
        (0 .. (@data_cell_span - 1)).each do |offset|
          rowcells = cells_for_row row, offset, last_data_col
          total = rowcells.collect { |cell| cell.value }.inject(0) { |sum, num| sum + num }
          set_value totcol + offset, row, total
        end
      end
    end
  end
end
