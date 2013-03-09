#!/usr/bin/ruby -w
# -*- ruby -*-

module ASCIITable
  class SeparatorRows < Hash
    # sets a separator for the row preceding +rownum+. Does not change the
    # coordinates for any other cells.
    def insert rownum, char = '-'
      self[rownum] = char
    end

    def append nrows, char = '-'
      self[nrows + 1] = char
    end

    # banner every +nbetween+ rows
    def add_every nrows, nbetween, char = '-'
      1.upto((nrows - 1) / nbetween) do |num|
        insert(1 + num * nbetween, '-')
      end
    end
  end
end
