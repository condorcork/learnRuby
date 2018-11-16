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
  y.hor_show()
#  
  y.ver_show() # false)
  y.hor_show(1)
  #
  puts '##Yotaku idx 3 古谷野 san'
  y.yoyaku(3, '6012')
  y.hor_show(2)
#  
  $fulldayDebug = true
  y.examine
  if ! y.are_you_ok?( "## Continue Y/N:")
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
  y.hor_show()
  puts "#---- Check ---"
  ###
  (0..4).each {|x|
    y.hor_show(x)   ## [ x ])
#    seq=y.sr_offdays_array( x )
#x    print "\n#Full Off No.#{x}  '", seq, "'\n\n"
  }

  
  if ! y.are_you_ok?( "---FOR ADJUST #-----")
    exit 0
  end

  (0..2).each {|i|
    puts "\n\n#ADJUST #{i}"
    y.adjust(i)
 #   break  if ! y.are_you_ok?
  }

  
 # if ! y.are_you_ok?('continue? ')
    exit 0
 # end

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
