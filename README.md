#---- Reinvent the wheel  !?
  def checkCase()
  #------ 
#    helper

##

#----- Bug ( debuged ) ------------------------
# syntax error, unexpected keyword_end, expecting tSTRING_DEND (SyntaxError)
#  end
#  ^~~
    #    puts "'#{strDay' }"               # !! Carefully !!
##    
#  18/11/28 menu_io.rb  -- separate to aonther file
#--------------------------    
# TO DO
#  I/O
#     Move Cursor and Toggle in the table
#
#             x getchar  without Return key
#              1.     just now  # done 2018-11-26(Mon) 15:43:29
#         replace with named_capture or more simple way in menu.io
#  History    
#     x save/load  a litte
#     x pop/ shift clear  11/28- almost

#     x Best Score  11/28 point only
#                 yet restore
#  show changed Days
#  Menu  ....
#     X   ShokiKA
#     X  Sel Action
#     X  Display HYO
#    Story
#  Miscel
#   Menu Done --> save data
#                 & use when next month
# 2.  control display Msg for test
#
# 3. month 12->1 New Year Mode
#    t  member + 2  --> member 1 (other show when result )
#    t  num_workers  --> same as above
#..................................
#  BUG : ref/include   
#    ^end
#    ==> Handle as 'end of module'
#........
# option
#  seq_workers REVETSE
#  Setting limitChangePWorker if short
#
# must 
#            x best Score point only(11/28-) 12/01 done 

##
bug      12/3
horizontal <-- vertical 
with error Attr
bug --->vertical
#
H(elp)/M(enu): show This Menu"
 9[0], Q[uit].   Exit
loop h Entered
: 69
#60# .. HYO ..
sel Do ==> 69
change horizontal 'false' Mode : Y/N
change horizontal 'false' Mode : Y/N
Horizontal Mode true changed
loop 69 Entered
: 62
#60# .. HYO ..
sel Do ==> 62
30  = OK: 0 +  Under: 30 + Over: 0
#def chk_BestScore
bestScore  -16 <> 56
   . . . . |1 2 3 4 5 6 7 8 9 + 1 2 3 4 5 6 7 8 9 + 1 2 3 4 5 6 7 8 9 + .
Dy|+-+-+-+-|+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-<<---  12 ----
  |. . . . |16. . . 20. . . . , . . . . + 1 . . . + . . . . 10. . . . 15
Traceback (most recent call last):
        6: from run.rb:127:in `<main>'
        5: from /data/data/com.termux/files/home/prj/WorkShop/learnRuby/CoreLogic.rb:1109:in `sel_MainMenu'
        4: from /data/data/com.termux/files/home/prj/WorkShop/learnRuby/CoreLogic.rb:1381:in `do_HYO'
        3: from /data/data/com.termux/files/home/prj/WorkShop/learnRuby/CoreLogic.rb:1651:in `show_Hyo'
        2: from /data/data/com.termux/files/home/prj/WorkShop/learnRuby/CoreLogic.rb:1562:in `hor_show'
        1: from /data/data/com.termux/files/home/prj/WorkShop/learnRuby/CoreLogic.rb:1562:in `each'
/data/data/com.termux/files/home/prj/WorkShop/learnRuby/CoreLogic.rb:1564:in `block in hor_show': undefined method `join' for "\x04\b[-":String (NoMethodError)
make: *** [makefile:11: CoreLogic.rb] Error 1
$
#
# 12/3 test part save/load_Case