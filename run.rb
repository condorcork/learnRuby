#!/usr/bin/env ruby
# coding: utf-8
#

#require './corelogic'
require './CoreLogic' 

def test_Reverse()
  dat='_ _*_x_X_'
  dat2=dat
  dat2=dat.gsub(/[X\*]/){|s|
    y.color_str(s,'REVERSE, GREEN')
  }
  dat3 = dat2.gsub(/\*/,' ')
    
  puts "  '#{dat2}'  <-- '#{dat}'"
  puts
  puts "  '#{dat3}'  <-- '#{dat2}'"
end


#----- MAIN ------
$fulldayDebug = false
members=4
y=Yotei.new(members, '2018-11-01')    #  # 11, 2)
=begin
a, b = y.change_IO()
p a
p b
=end

#... Prepare for Prevmonth
  # 'xx  ''xxx'    --> 0(1)
  y.prepare(0, 'xx  ')
  # 'x  x''xx__'   --> 1(2)
  y.prepare(1, 'x  x')

  # ' xxx''__xx'   --> 3(4)
  y.prepare(2, ' xxx')
  # ' DDx '' DDD'  special
  y.prepare(3, 'DDx ')
  #
  y.hor_show(1)
  
  #
 #######################
  ##
#  y.test_data
#  y.hor_show()
#  y.testMain
#
  ##
#  test_Reverse
#
#  y.examine()
#  y.hor_show()
#  
 #  y.ver_show() # false)
 # y.hor_show(1)
  #
  puts '##Yotaku idx 3 古谷野 san'
  y.yoyaku(3, '6012')
  y.hor_show(2)
#  
  $fulldayDebug = true
  y.examine
  if ! y.ok_YN?( "## Continue Y/N:")
    exit 0
  end

  y.hor_show(3)
  #
  # Start to Think
  #
  y.save_Case(true)
  puts '# ======== Saved end of Yotaku idx 3 古谷野 san'
#
  #... PreSet  Fill days by Patern ....

puts "#---- PRESET by Pattern---"
y.pre_set([0,1,2])
y.ver_show()

#  def presetMultiWorker(idx,d, x)p

y.presetKoyano(members - 1)  #, [0,1,2,6], [3,5])
#y.ver_show()

#   y.save_Case  
  print "\n\n===============Saved after Koyano\n"
  y.hor_show([0,1,2])
  puts "#---- Check ---"
  ###
=begin  
  (0..4).each {|x|
    y.hor_show(x)   ## [ x ])
#    seq=y.sr_offdays_array( x )
#x    print "\n#Full Off No.#{x}  '", seq, "'\n\n"
  }

=end  
  if ! y.ok_YN?( "---FOR ADJUT #-----")
    exit 0
  end

  maxPoint={}
  maxPoint[:point]=0
  maxPoint[:Case]=[]

  puts "\n\n#ADJUST \n"
  point =  y.adjust_Block( [0,1,2,0,1,2], 8, reset=true)
  
  
  p point
  #p maxPoint[:point]
  #p maxPoint[:Case]
  exit 
  

  maxPoint={}
  maxPoint[:point]=0
  maxPoint[:Case]=[]


  
  (0..3).each {|i|
    puts "\n\n#ADJUST #{i}\n"
    point = y.adjust()
    p point
    p maxPoint[:point]
    if point > maxPoint[:point]
      maxPoint[:point] = point
      maxPoint[:Case] = [ i ]
    elsif point == maxPoint[:point]
      maxPoint[:Case] <<  i 
    end
 #   break  if ! y.ok_YN?
  }
  puts "# BEST SCORE is #{maxPoint[:point]}"
  puts "  # Case #{maxPoint[:Case]}"
  
 #if ! y.ok_YN?('continue? ')
 #  exit 0
 #end

 maxPoint[:Case].each{|i|
   puts "\n\n#ADJUST #{i}\n"
   point = y.adjust(i, false)
   wrker, day = y.sel_ToggleOneWorker()
   print "worker '", wrker,"'  day '", day,"'\n"
   
   if y.act_ToggleOneWorker(wrker, day)
     y.hor_show(wrker)
   else
     puts "!!NOT AVAILABLE INPUT"
     if ! y.ok_YN?('continue? ')
       break
     end
   end
 }
 exit
  #---------
y.examine()
#y.ver_show()
y.hor_show()
#
## y.evaluate([0,1,2,3])
# y.shift_to(2,-1)
#y.ver_show()
#y.hor_show()
#puts "#---2nd. - Check ---"
# y.shift_to(2,-2)
# y.hor_show()
#
y.think(3)
y.hor_show()
puts "#---- End Check ---"
y.think(2)
y.hor_show()

y.load_Case
puts "#..................$ load_Case for after Koyano"
## y.hor_show
#
#y.load_Case
#puts "#.........---------- load_Case for Set Yoyaku"
#y.hor_show

## y.load_Case
puts "#.........---------- load_Case Empty"
y.hor_show()


puts "==== End of main ===="
#=== End of Prog File ===



__END__
#nn = char_selected( "chose A B C\n A : Abc\n B : Bbb\n",'ABC')
#p nn
#=end
print y.color_str("RED,BLINK", "RED,BLINK"), "\n"
print y.color_str("GREEN,BLINK", "GREEN,BLINK"), "\n"
print y.color_str("RED,REMOVE", "RED,REMOVE"), "\n"
print y.color_str("RE MOVE", "RED,REMOVE"), "\n"
print y.color_str(" "), "\n"
exit

##
puts "======="
a= y.str_Attr( 1 )
b= y.str_Attr( 2 )
c= y.str_Attr( 3 )
d= y.str_Attr( 4 )

print a," ", b, " ",  c, " ",d, "\n"
puts "======="
exit 
