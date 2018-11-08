#!/usr/bin/env ruby
# coding: utf-8

files = ARGV
# [ 'FL1 with include':   ,
#   'FL2 newly made'  :   ,
#   'FL3 require FL2' :
#  ]
##
=begin
FL1
line1
line2
# Here replaced
#---------------
include 'moduleX'
#-- Replace from Here with moduleX--
#include 'moduleX'
   ::
#module ModuleX   # comment 
   ::
   ::
#end              # comment
#-- Replace until End of moduleX ---
   :
line_X
   :
end

=end


lines=ARGF.read
lines.each_line do |l|
  if l =~ /^include[ \t]+'([^']+)'/
    file = $1
    puts "## <#{file}> included"
#    ARGV = [ file ]
#    print inc_data  = ARGF.reaf
    puts "## <#{file}> included"  
  else
    print l
  end
  #
  
end
