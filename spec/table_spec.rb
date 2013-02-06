#!/usr/bin/ruby -w
# -*- ruby -*-

require 'asciitable/table'
require 'asciitable/data'

class DogData < ASCIITable::DefaultTableData
  def initialize 
    super 'name', :breed, :state
    add 'lucky', 'mixed', 'Illinois'
    add 'frisky', 'dachshund', 'Illinois'
    add 'boots', 'beagle', 'Indiana'
    add 'sandy', 'ridgeback', 'Indiana'
    add 'cosmo', 'retriever', 'Virginia'
  end
end

describe ASCIITable do
  it "last column should be the number of data columns" do
    table = ASCIITable::Table.new DogData.new
    table.cells.last_column.should == 2
  end

  it "last row should be the number of data rows" do
    table = ASCIITable::Table.new DogData.new
    table.cells.last_row.should == 5
  end

  it "should do something advanced" do
    pending "awaiting implementation"
  end
end
