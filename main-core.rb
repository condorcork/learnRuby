#!/usr/bin/env ruby
# coding: utf-8


#......
# 2018-11-02(Fri) 17:35:00
#
# 2018-10-28(Sun) 15:45:38

# 10-29(Mon) 15:43
# 10-30(Thu) 12:49
# 2018-10-30(Tue) 18:57:15

require './corelogic'
'

#---- no use
# puts '#... Ready state of each day'
#.... Test methods
# days=[0, 1, 2, 3, 4, 5]
# chk_workers=[0,1,2,3]
# test_cnt_filled(y, days, chk_workers, 1)

def char_selected(prompt='chose :', srcs)
  print prompt
  while true
    res = gets.chop!
    case res
    when /[#{srcs}]/i
      
      return res
      
    end
  end
end

def are_you_ok?(prompt='ok ? [y|n]:')
  while true
    print prompt
    res = gets
    case res
    when /^[yY]/
#      puts "you say yes!"
      return true
    when /^[nN]/, /^$/
#      puts "you say no!"
      return false
    end
  end	
end


#----- MAIN ------
=begin
prompt= [
  "Chose A B C",
  "   A: fghhhjj",
  "   B: bbbbbb ",
  "   Q: Quit   " ].join("\n")
sel=prompt.match(/[^A-Z]([A-Z]):/)
p prompt
p sel

nn = char_selected( "chose A B C\n A : Abc\n B : Bbb\n",'ABC')
p nn
=end

#... New 
puts 
puts "y=Yotei.new(members, 11)"
puts "  y.prepare(3, 'DDx ')"
members=4
y=Yotei.new(members)  # 11, 2)

#... Prepare for Prevmonth
  # 'xx  ''xxx'    --> 0(1)
  y.prepare(0, 'xx  ')
  # 'x  x''xx__'   --> 1(2)
  y.prepare(1, 'x  x')

  # ' xxx''__xx'   --> 3(4)
  y.prepare(2, ' xxx')
  # ' DDx '' DDD'  special
  y.prepare(3, 'DDx ')
 #######################

#
  y.examine([0,1,2,3], true)
#  
  y.ver_show([0,1,2,3], false) # false)
  y.hor_show([0,1,2,3], true)
  #
  puts '##Yotaku idx 3 古谷野 san'
  y.yoyaku(3, '6012')
  y.hor_show([3])
  
  y.hor_show([0,1,2,3])
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

#  def presetMultiWorker(idx,d, x)

y.presetKoyano(members - 1)  #, [0,1,2,6], [3,5])
#y.ver_show()

#   y.save_Case  
  p "===============Saved after Koyano"
  y.hor_show()
  puts "#---- Check ---"
  ###
  




  if !are_you_ok?()
    exit 0
  end

  [0,1,2].each {|i|
    y.adjust(i)
  }
  
  if !are_you_ok?('continue? ')
    exit 0
  end

  #---------
y.examine([0,1,2,3])
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
y.hor_show
puts "#---- End Check ---"
y.think(2)
y.hor_show

y.load_Case
puts "#..................$ load_Case for after Koyano"
## y.hor_show
#
#y.load_Case
#puts "#.........---------- load_Case for Set Yoyaku"
#y.hor_show

## y.load_Case
puts "#.........---------- load_Case Empty"
y.hor_show


puts "==== End of main ===="
#=== End of Prog File ===
