riellibdir = File.dirname(__FILE__)

$:.unshift(riellibdir) unless
  $:.include?(riellibdir) || $:.include?(File.expand_path(riellibdir))

module ASCIITable
  VERSION = '0.0.1'
end
