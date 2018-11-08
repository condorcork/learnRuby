#!/usr/bin/env ruby
##  color.rb
##   from https://qiita.com/hidai@github/items/1704bf2926ab8b157a4f
#    this program
##
#    from http://ascii-table.com/ansi-escape-sequences.php
#
#Set Graphics Mode:
#  Calls the graphics functions specified by the following values.
#  These specified functions remain active until the next occurrence of this escape sequence.
#  Graphics mode changes the colors and
#   attributes of text (such as bold and underline) displayed on the screen.
#
### Text attributes
# 0  all attributes off
# 1	Bold on
# 4	Underscore (on monochrome display adapter only)
# 5	Blink on
# 7	Reverse video on
# 8	Concealed on
# 
###Foreground colors
# 30	Black
# 31	Red
# 32	Green
# 33	Yellow
# 34	Blue
# 35	Magenta
# 36	Cyan
# 37	White
## 
### Background colors
# 40	Black
# 41	Red
# 42	Green
# 43	Yellow
# 44	Blue
# 45	Magenta
# 46	Cyan
# 47	White
##
##
####
# Esc[Value;...;Valuem	Set Graphics Mode:
#      Calls the graphics functions specified by the following values.
#      These specified functions remain active until the next occurrence of this escape sequence.
#      Graphics mode changes the colors
#      and attributes of text (such as bold and underline) displayed on the screen.
 
##Parameters 30 through 47 meet the ISO 6429 standard.
#
print "  --   "
for b in 40..47
  s = b.to_s
  print "\033[", s, "m    ", s, "   \033[0m "
end
print "\n"
for c in [ 30, 31, 32, 33, 34, 35, 36, 37, 90, 91, 92, 93, 94, 95, 96, 97 ]
  s = c.to_s
  print "\033[", s, "m ", s, "   \033[0m "
  for b in 40..47
    s = c.to_s + ";" + b.to_s
    print "\033[", s, "m ", s, "   \033[0m "
  end
  print "\n"
  for a in [ 1, 4 ]
    s = c.to_s + ";" + a.to_s
    print "\033[", s, "m ", s, " \033[0m "
    for b in 40..47
      s = c.to_s + ";" + b.to_s + ";" + a.to_s
      print "\033[", s, "m ", s, " \033[0m "
    end
    print "\n"
  end
end

puts
puts
puts

print "\033[", 5, ";", 1, "m", "BLINK Bold", "   \033[0m 5, 1 \n"
print "\033[", 4, ";", 1, "m", "underline Bold", "\033[0m 4, 1 \n"
###Foreground colors
# 30	Black
# 31	Red
# 32	Green
# 33	Yellow
# 34	Blue
# 35	Magenta
# 36	Cyan
# 37	White
## 
### Background colors
# 40	Black
# 41	Red
# 42	Green
# 43	Yellow
# 44	Blue
# 45	Magenta
# 46	Cyan
# 47	White
#
# 0  all attributes off
# 1	Bold on
# 4	Underscore (on monochrome display adapter only)
# 5	Blink on
# 7	Reverse video on
# 8	Concealed on
#
print "\033[", 43, "m", "BackGround Yellow", "\033[0m 43 \n"
print "\033[", 43, ";", 32, "m", "Back Yellow    ForGround Green", "\033[0m 43 32\n"
print "\033[", 43, ";", 32, ";", 5, "m", "Back Yellow  For Green Blink", "\033[0m 43 32 5\n"
print "\033[", 47, ";", 5, "m", "Back White Blink", "\033[0m 47, 5\n"
print "\033[", 47, ";", 32,";", 5, "m", "Back White  Forg Black Blink", "\033[0m 47, 5\n"
#
print "\033[", 5, ";m", "Reverse On", "\033[0m 47, 5\n"
print  "Continue", "\033[0m<OFF>?\n"
