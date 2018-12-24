# coding: utf-8
module MenuIo

require 'io/console'
require 'io/console/size'

  
  #.............................
  def ok_YN?(prompt="continue \n  Yes: Y, y, Cr\n  No: N, n\n  Q[q] stop [Y|N|\\n|Q] ? :")
  #.............................
    print prompt
    while (key = STDIN.getch) != "\C-c"
      case key  # .inspect
      when /[yY]/
        return true
      when /[N]/i
        puts "[N]o "
#        Exit 1
        return false
      when /Q/i
        puts "EXIT 0"
        exit 0
      when "\r"
        return true
      end
      puts "'#{key}' '#{key.inspect}'"
    end
    puts "\C-c"
    exit 1;
  end

  #.........................
  def sel_MainMenu()
  #.........................
    prompt=<<-EOF
[ MAIN MENU ]
0.  Set Initial Env
1[0]..[sMenu] 
2[0]..[sMenu] Change CONDTION 
 21.Shift seq  22. Pattern etc.
3[0]..[sMenu] SELECT Action 
 31.Blank 34.Koyano(Prepared) 37. Adjust_Round
40..[sMenu] Go back to DONE Stat.
 41.Blank 42.Blank_ 43.Koyano
 44.Pattern 45.Prev 48.Best <49> 
5[0]..[sMenu] INFO
 51.Best Score, show HYO
60..[sMenu] HYO:Change hori/vert Mode
 61/62. Hyo only/ Hyo with Detail
70. ENDING (decide A.B) & Print
70.
8[0]. Manual Handling
 H(elp)/M(enu): show This Menu"
 9[0], Q[uit].   Exit 
EOF
    puts prompt
    
    while true
      print ": "
      l=gets.chop
      case l
      when /^(\s*(\d+)\s*)$/
        menu = l.to_i
        case menu
      #--  Condition 0,1[0], 2[0], 3[0]
        when 0   # Initial set & Check
          puts '# Initial Env'
          do_BaseTest()
        #          do_test
 #         do_initEnv
        when 1, 10, 11..19    # 
          # 11. Shift seq  12. Pattern etc.
          do_ChngActCond(menu) # 20
        when 2, 20, 22
          # Change CONDTION #
          do_ChngActCond(menu) 
        when 3, 30, 31..39
        #-- Action    
          do_Action(menu)
        when 4, 40, 41..49
        # 40..GoBack #
          do_GoBack(menu)
        when 50..59
#   5[0]..[sMenu] INFO          
#   puts ". get Best Scend"
        #         do_HYO(menu)
          #get_BestScore
        when 60..69
          do_HYO(menu)
        when 70..79
          puts "do_Ending"
          do_Ending
    #      return 60
        when 8, 80
          puts "Manual Handling"
          sel_ToggleExchange()
        when 9, 90
          puts "Exit"
          exit 0
        end
        
      when /^((\b*(H)(elp)*\b*)|Menu)$/i
        puts 'when /^((\b*(H)(elp)*\b*)|Menu)$/'
        puts prompt
      when /^\b*Q(uit)*\b*/i
        puts "when /^\b*Q(uit)*\b*/i"
        puts "Exit"
        exit 0
      end # case l
      puts "loop #{l} Entered"
    end # while true
  end # sel_MainMenu()

  #.............
  def do_ChngActCond(menu) # 10  
  #.............
    puts '#10# do_ChngActCond'
    if menu == 10 or menu == 1
      puts '11 Seq. of Priority'
      puts '12 pattern   Q[uit] :'
      while true
        l=gets.chop
        if l =~ /Q/i
          # no action
          return
        else
          case l.to_i
          when 11, 12..15
            menu = l.to_i
            break
          end
        end

      end # while true
    end # if 
    #
    case menu
    when 11
      set_nextSeq
    when 12
      set_NextPattern
    when 13
      puts '# change PATTERN'
      mk_set_Pattern
    end # case menu
  end #do_ChangeCond

  #.............................
  def do_GoBack(menu)   # 40 GoBack
  #.............................
    puts "#do_GoBack( '#{menu}' )"
    if menu == 4 or menu == 40
      puts ' 41.Blank  42.Blank_ 43.Koyano'
      print ' 44.Pattern  45.Prev 48.Best [49] Q.quit:'
      while true
        l=gets.chop
        if l =~ /\s*Q\s*/i
          # no action
          return
        else
          case l.to_i
          when 41..45,48,49
            menu = l.to_i
            break
          end
        end
      end # while true
    end
    puts "nenu GoBack '#{menu}'"
    @isSaveMode = false
    case menu
    #--- Prepare to 
    when 41
      caseName='Blank'
    when 42
      caseName='Blank_'
    when 43
      caseName='K_Yoyaku'
   #--- After some Action
    when 44
      caseName='Pattern'
    end
    #
    @isSaveMode = false
    case menu
    when 41..44
      ret = load_NamedCase(caseName)
      if ret
         @wrkdays = ret
         show_Hyo(false)
      end
   when 45
      ret= load_PrevCase
      if ret
        @wrkdays = ret
        show_Hyo(false)
      end
    when 48
      if load_BestScore != nil
        show_Hyo
      end
    when 49
      all_SavedCase
    end
  end

  #.............................
  def do_get_BestScore
  #.............................
    case @bestScore[0][:num]
    when 0
      puts '#!! best score Not YET Gotten'
      return
    when 1
      load_BestScore
    when 2
    end
  end # def do_get_BeastScore
  
  #.............................
  def do_Ending(isContinue=true)
  #.............................
    show_Hyo
    if !ok_YN?('test marshal.file ')
      return
    end
=begin    ### To File 
file = File.open("/tmp/marshaldata", "w+")
Marshal.dump({:a => 1, :b => 3, :c => 5}, file)

# fileポインタが最後の位置にあるので最初から読み込めるように以下を実行
file.rewind
# => 0
Marshal.load(file)
# => {:a=>1, :b=>2, :c=>3}
=end
#puts 'test File Marshal'    
#    show_Hyo
    file = File.open("./data/marshal_WrkDays", "w+")
    Marshal.dump(@wrkdays, file)
    show_Hyo
    sel_ToggleExchange()    
    show_Hyo
    puts 'Get From File '
    file.rewind
    @wrkdays = Marshal.load(file)
    show_Hyo
  end

  def save_fileMarshal
    file = File.open("./data/marshal_WrkDays", "w+")
    Marshal.dump(@wrkdays, file)
  end

  def Adust_Best
=begin               
#      puts "# ShiftTo All Members & get Best"
      save_Case('Before Shift')
      score=[]
      idxbest = 0
      # Koyano Can Not Shift 
      (0...@num_workers - 1).each do |w|
        cs= load_Case
        @wrkday2 = cs

        shift_to(w, 1)
        show_Hyo
        
        score[w] = get_Score
        if w == 0
          idxbest = w
        else
          if score[w] > score[idxbest]
            idxbest = w
          end
        end
      end
      #           0 1 2   w(orker)
      #           2 1 0   before
      #  idxbest
      #  when 2 (3-1) - 2 = 0  current
      #       1    2  - 1 = 1  before
      #       0    2  - 0 = 2  before
      ipos = ( @num_workers - 1 ) - idxbest 
      CasePop(ipos)
      cs = load_Case(nil, true)    # load & pop(del)
      if cs != nil
        @wrkday2 = cs
      end
      show_Hyo
    when 43
      puts "do Adust_Round"
      adjust_Round()
      show_Hyo()
      #adjust()
    end
=end
  end
  
  #............................
  def do_Action(menu, *wrker_dir_ndays)    # 3. 30.
    #.............................
    menuData=<<-EOF
[ Action MENU ]
31. Blank with  Prev Month data
32. Koyano Yoyaku
33. put Pattern
34. set Koyano (before or after Holidays)
35.. Adjust
36.. ShiftTo Right / Left
37. Adjust Round & Occurence No Limit
38.. Continuous Do (Select Number )  
39. Mnual Handling (inc  Adjust Holiddays)
 H(elp)/M(enu): show This Menu"
 Q[uit].   Exit Menu
EOF

    puts " '#{wrker_dir_ndays}'"
  
    print menuData
    wrkr = dir = nday = nday2 = nil
    
    # check Complete?
    case menu
    when 3, 30 #
      isReady = false
    when 31..34,37,39
      isReady = true
      puts "    menu 31..34, 47,39"
      puts menu
    when 35, 36
      
    end
                         # sub menu or param
     menu, wrkr, dir, ndays, ndays2 = get_FromMenu_30(menuData, menu) if !isReady

     puts "## Menu=#{menu}    wrkr '#{wrkr}'  dir '#{dir}'  ndays='#{nday}' ndays2='#{nday2}'"

     @isSaveMode = true
     case menu
     when 31
       puts "#      load_NamedCase('Blank_')"
       mk_WrkDays
       lastdays=get_Last4days
       (0...@num_workers).each{|w|
         set_PrevMonth(w, lastdays[w])
       }
     when 32
       puts "#    do  K_Yoyaku"
       yoyaku(3, '6012')
     when 33
       puts "#      Pattern"
       put_Patterns
     when 34
       puts "#      set_Koyano"
       presetKoyano(@idx_Koyano)
     when 35
       puts "#      adjust(wrkr)"
       adjust(wrkr)
     when 36
       puts "# ShiftTo right/left  for #{wrkr}"
       shift_to(wrkr, dir )
       pp
a1     #      show_Hyo      
     when 37
       puts "#      adjust_Round"
       adjust_Round
       adjust_Kyu
     when 38
       puts "# do Exexctuing Karte (not yet)"
     when 39
       puts "# Manual Doing"
       sel_ToggleExchange()
     else
       puts "menu else"
       @isSaveMode = false
       return
     end # case menu
     #
     @isSaveMode= false
  end # do_Action
                     
                     #
  #............................
  def get_FromMenu_30(menuData, menu)
  #.............................
    puts "# def get_FromMenu_30( menu=#{menu} )"
##    print menuData    
    # get  menu num.
    case menu
    when 3, 30
      loop {
        menu=get_MenuNum(menuData, '(H|Q)')
        case menu.to_i
        when 31..34,37,39
          return [ menu  ]
        when 35, 36, 38
          break
        when 61
          show_Hyo(false)
        else
          if menu == 'Q'
            return 'Q'
          end
        end
      }
    end
      
    # get detail param in menu 35 36
    #    menu, wrkr, dir, nday, nday2 = get_FromMenu_30_Sub
    puts '35: adjust wrkr'
    puts '36: shift(slide)'
    puts '  wrker ((-|+)*direction ( fromDay, toDay))'

    puts '^\s*(\d)(\s+(-*\d+)(\s+(\d+)\s*,\s*(\d+))*)*\s*$'
    while true
      l=gets.chop
      puts "'#{l}'"
      l =~ /^\s*(\d)(\s+(-*\d+)(\s+(\d+)\s*,\s*(\d+))*)*\s*$/ 
      case l
      when /Q/i
        return [ 'Q' ]
      when /^\s*(\d)(\s+(-*\d+)(\s+(\d+)\s*,\s*(\d+))*)*\s*$/
        ret = []
        ret << menu
        ret << $1.to_i 
        ret << $3.to_i if $3 != nil
        ret << $5.to_i if $5 != nil
        ret << $6.to_i if $6 != nil
 #       puts ret
#        puts "#{$1}'  '#{$2}' '#{$3}' '#{$4}' '#{$5}'  '#{$6}' '#{$7}'"        
        if menu == 36  # when ShiftTo
          if ! rply=ok_YN?("\nOK Y/N/Q")
            menu = 90
          else
            break
          end
        elsif menu == 35 # Adjust
          puts "Adjust  Worker #.'#{ret[1]}'"
          if ! rply=ok_YN?("OK Y/N/Q")
            menu=90   # No
            ret=[ 90 ]
          else
            return ret
          end    
        end # if mene
      end #case l
    end # while
    return ret
  end #  def get_fromMenu_30
  
  #.............................
  def do_HYO(menu)     # 60..
  #.............................
    puts "#60# .. HYO .."
    if menu == 6 or menu == 50
      puts "\n 61. HYO only"
      puts " 62. HYO with DatailU"
      puts " 69. Change Horizontal/ Vertival Mode"
      print ' 61 62 69 Q :'
      while true
        ret = gets.chop
        if ret =~/^\s*(\d\d|Q)\s*/i
          if ret =~/Q/
            return
          end
          print  "<> '#{ret}'  => '"
          menu=ret.to_i
          puts "'   '#{menu}'"
          break
        end
        puts "loop #{ret}"
      end
    end
    #  def do_Change
    puts "sel Do ==> #{menu}"
    @isSaveMode = false
    case menu
    when 69
      if ok_YN?("change horizontal '#{@horizontal}' Mode : Y/N" )
        msg="\nchange horizontal '#{@horizontal.inspect}' Mode : Y/N "
        if ok_YN?( msg ) == true
          @horizontal = !@horizontal
          puts "\nHorizontal Mode #{@horizontal} changed"
        end
      end                
    when 61
      show_Hyo(false)
    when 62
      show_Hyo()
    end
  end # do_HYO
  #
  
  #.........................
  def sel_ToggleExchange(msg=nil)
  #.........................
    puts msg if msg != nil
    prompt=<<-EOF
[ Manual HANDLING ]
 'worker, day':     Toggle On/Off 
 'w1,day1 w2,day2': Exchange 
                     day1 day2
  'U','M' :    Upper (Main) Menu
  'S' :    Show Hyo
  'Q' :    Quit from This Menu  
EOF
    print prompt
    print ': '
    ret=[]
     while true
      l=gets
      l.chop!
      case l
      when /((\d), *(\d+))([ \t]+(\d),[ \t]*(\d+))*/
        ret[0]=$2.to_i
        ret[1]=$3.to_i
        if $4 != nil
          ret[2]=$5.to_i
          ret[3]=$6.to_i
          puts "exchange"
          do_Exchange(ret[0], ret[1], ret[2], ret[3])
        else
          do_ToggleDay(ret[0], ret[1])
        end
        @isSaveMode = true
        examine
        @isSaveMode = false
        return ret
      when /^[ \t]*Q\s*/i
        return
#        puts "Exit"
#        exit 0        
#        break
      when /^[ \t]*S\s*/i
        show_Hyo
        print prompt
      when /^[ \t]*(U|M)\s*/i
        return 'M'
      end
    end
  end # def sel_ToggleExchange(msg=nil)


  #-----------------------
  def get_MenuNum(menuData, quitQ='Q')
  #-----------------------
    puts menuData
    loop {
      print ': '
      l=gets.chop
      case l
      when /^\s*(\d\d*)\s*$/i
        return $1.to_i
      when /^\s*#{quitQ}\s*$/i
        return 'Q' if quitQ!=''
      end
    }
  end #  def get_MenuNum(menuData)
  
  #............................
  def get_MenuDat(ptrn, param)
  #...........................
    puts ptrn
    while true
      menu=gets.chop!
      ret = {}
      if menu =~ /#{ptrn}/ 
        param.each {|k, v|
          ret[k] = $~[v]
          p ret
          return ret
        }
      end          
    end
  end # get_MenuDat

end # MenuIo
