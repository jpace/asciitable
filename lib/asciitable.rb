libdir = File.dirname(__FILE__)

$:.unshift(libdir) unless
  $:.include?(libdir) || $:.include?(File.expand_path(libdir))

module ASCIITable
  VERSION = '0.0.1'
end
