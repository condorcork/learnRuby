#!/usr/bin/env ruby
# coding: utf-8
#

#require './corelogic'
require './CoreLogic' 
  #
 
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


 def preparePrevMonth(y)
#... Prepare for Prevmonth
  # 'xx  ''xxx'    --> 0(1)
  y.prepare(0, 'xx  ')
  # 'x  x''xx__'   --> 1(2)
  y.prepare(1, 'x  x')

  # ' xxx''__xx'   --> 3(4)
  y.prepare(2, ' xxx')
  # ' DDx '' DDD'  special
  y.prepare( 3, 'DDx ')    # y.@Koyano
  #
 # y.hor_show(false)
 end

#----- MAIN ------
 $fulldayDebug = false
 members=4
   y=Yotei.new(members, '2018-11-01')    #  # 11, 2)
#  y=Yotei.new(members) 
  y.save_Case('Blank')
  preparePrevMonth(y)
  y.save_Case('Blank_')
  y.hor_show( false )   


##  y.test_SusMenu

  #
  y.yoyaku( 3, '6012')   # 
  y.hor_show(false)    
  y.save_Case('K_Yoyaku')
#
# from Here Star
#  to Actual Handling
#
  y.put_Patterns()
  y.save_Case('Pattern')     
  y.hor_show(false)
y.test_slide_Part
exit



  
  y.test_GoBack
  puts "returned  GoBack"
  y.all_SavedCase
  #
  if y.ok_YN?("do Koyano Preset y/n")
    y.presetKoyano( 3 )   # y.@Koyano )  #, [0,1,2,6], [3,5])
    y.save_Case("KoyanoPreSet")     
    y.ver_show()
    print "\n\n===============Saved after Koyano\n"
    y.hor_show()
  end
  
  puts "#---- Check ---"
#  
  $fulldayDebug = true
#  y.examine
#  if y.ok_YN?("Main Menu Y/N/Q:")
#    y.sel_MainMenu
#    exit 0
#  end
  
  #-----------------------
  # Start to Think
  #-----------------------
y.save_Case("Initial")                # initail stat
  puts '# ======== Saved end of Yotaku idx 3 古谷野 san'
#
  #... PreSet  Fill days by Patern ....
  puts "#---- PRESET by Pattern---"
  y.put_Patterns()
  y.save_Case("Prepared")     
  y.ver_show(false)

  #####
  if y.ok_YN?("do Koyano Preset y/n")
    
    y.presetKoyano( 3 )   # y.@Koyano )  #, [0,1,2,6], [3,5])
    y.save_Case("Koyano_")     
    y.ver_show()
    print "\n\n===============Saved after Koyano\n"
    y.hor_show()
  end
  puts "#---- Check ---"
  ###
##
#  y.test_load_saveCase
#  exit  
  if  y.ok_YN?( "--- Do ADJUST Round #--- Y/N/Q :")
    point =  y.adjust_Round( reset=true )
  end

  y.sel_MainMenu
  exit
  

  
puts "=========================="
y.load_Case()  
  maxPoint={}
  maxPoint[:point]=0
  maxPoint[:Case]=[]

#  puts "\n\n#Adjust_Round\n"
point =  y.adjust_Round( reset=true )
  
p point
  #p maxPoint[:point]
  #p maxPoint[:Case]

 while true
   w1,d1,w2,d2 = y.sel_ToggleExchange()
   puts "#{w1} #{d1} #{w2} #{d2}"
   if w2 != nil
     if ! y.do_Exchange(w1, d1, w2, d2)
       puts "#!!! Not Done do_ToggleDay(#{w1}, #{d1}   #(w2}, #{d2})"
       next;
     end
   elsif w1 == nil
     next
   elsif w1 == 'M'
     y.sel_MainMenu()
   else
     if ! y.do_ToggleDay(w1, d1)
       puts "#!!! Not Done do_ToggleDay(#{w1}, #{d1})"
       next;
     end
   end
   y.ver_show()
   # y.hor_show

   #   y.show_Result
   #  y.examine
 end

 y.sel_MainMenu
 exit

 #---------------
  maxPoint={}
  maxPoint[:point]=0
  maxPoint[:Case]=[]


  
  (0...@num_workers).each {|i|
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
     y.hor_show()
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
y.think( 3 )  #   y.@Koyano)
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
c= y.str_Attr( 3)
d= y.str_Attr( 4 )

print a," ", b, " ",  c, " ",d, "\n"
puts "======="
exit 
##
#  Test do_ToggleDay 
 (4 .. 30).each do |d|
   (3..3).each {|w|
     if ! y.do_ToggleDay(w, d)
       puts "#!==== Error do_ToggleDay( #{w}, "#{d} )"
     end
   }
 end  
 y.hor_show()
 (1...4).each {|w|
   puts y.strStatus_Worker(w)
 }
 puts y.strStatus_Place
 puts "Score =", y.get_Score
 exit 0
