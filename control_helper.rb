# coding: utf-8
module ControlHelper

  #
# [0.. @num_workers + 1(for check)][0..34]
# [0.. @num_workers][0..34]
#     ' ' : free
#     'x' : kinmu
#     'D' : Dame (antherplace Kinmu)
#     '*' : Off Day           # changable
#     'A','B' :  OnDay ( Shift ) 
#     'X' : Upper case fixed
# 
#................
  #----- Initailze -------  
  def init_InitVarCon(members, date)
  #-----------------------
#.....  debug Display .....
@debug_do_Exchange = false
@debug_seq_WorkersSeq  = false
@debug_adjust_Round = false
#........
    
    #--- Constant ----
    @num_workers = members
    @num_workers_p_day = 2    # Teiin
    #-----   Patamater to Change CONDITION ----
    # in adjust_Round  Max or Limit  change / workers
    @limit_change = 4
    #
    @templateSrc=[]
    @templateSrc[0]=('xxx  '*8).split('')     #
    @templateSrc[1]=('xxxx  '*7).split('')
    @templateSrc[2]=('xxxxx '*5).split('')
    #
    @templateSrc[3]=('xxx  xx '*5).split('')
    #
    @template=@templateSrc.shift
    

    #-----  End Patamater to Change CONDITION ----
    #
    @Koyano = @num_workers - 1

    #--- Date ---- 
    if date.day < 7
      @month_16= date.month
      @year_16 = date.year
    else
      @month_16=date.next_month.month
      @year_16 = date.next_month.year
    end
 #
    # 
    @num_days16= daysOfMonth(@year_16, @month_16)
    @wday_16 = Date.new(@year_16, @month_16, 16).wday
    @theMonthRange = (4 ... 4 + @num_days16)       # idxs  of Range of the MONTH (True dat)
    if @theMonthRange.size != @num_days16
      puts "#=* Range Error"
      exit 1
    end
    puts " This has #{@num_workers} members"
    puts " Taiin = #{@num_workers_p_day}"
    puts " #{@year_16}-#{@month_16} has #{@num_days16} days."
    puts "           #{@month_16}-16  #{%w(Su Mo Tu We Th Fr Sa)[@wday_16]}(#{@wday_16}) "
    #
    define_OnOff_Day()    # define  the Day to work / not   # yOn, Off
    
    #
 
    # === Working Data ===    
#    @wrkdays=Array.new( @num_workers + 1, Array.new(35, ' ') )
    @wrkdays=Array.new( @num_workers, Array.new(35, ' ') )    # NO check Area 
    
    # === Data ====
    # check info & views

    #--- Paramater ------
    # from file if exists prev month 
    @seq_workers=(0...@num_workers).map{|w| w}  #[0,1,2,3]
    @seq_workers=@seq_workers * 10
    @seq_workers.shift   ### 
    
    ## status  for each worker
    @chk_workers={}
    @chk_workers[:OnDay]=Array.new( @num_workers )
    @chk_workers[:OnDayAll]=Array.new( @num_workers )   # including workdays of other places 
    @chk_workers[:OffDay]=Array.new( @num_workers )
    #   for view
    @chk_workers[:WithFullOffDay]=Array.new( @num_workers )
    @chk_workers[:FullOffDays] = Array.new( @num_workers )

    ## status for Each day 
    @chk_Place = {}
    @chk_Place[:numDay]=Array.new( 31+4, 0 )
    @chk_Place[:isOK]=Array.new( 31+4 , false)
    #    for View ( show )
    @chk_Place[:dayView]=Array.new( 31+4, ' ' )
    #
    @prevCase=nil     # marshal.dump Default

#    @serCase=[]
    @bestScore = {}   #  :point, :num?  :case :env
    @bestScore[:num] = 0
    @bestScore[:case] = []
    @bestScore[:env] = []   # seq_workers etc
  end #
  
  #
  #----- Date --------
  #.............................
  def daysOfMonth(year, mon)
  #.............................
    case mon
    when 1,3,5,7,8,10,12
      31
    when 4,6,9,11
      30
    else 2
      if Date.new(year, 2, 1).leap?
        29
      else
        28
      end
    end
  end

  def nextMonth(month=nil)
    Date.new(@year_16, @month_16, 28) + 28
    
  end


  #
  #  Constant 
  #
  #
  #..................................
  def define_OnOff_Day()
  #..................................
    # 'X", 'A', 'B'
    @day_ON = 'XABT'     # Toumu (24h)
    # ' ','*'                   
    @day_OFF = ' *'
    # 'X', 'A', 'B', and 'D'

    @day_ON_ALL = "#{@day_ON}D"
  end
  #
  #...............................
  def isOffDay(day)   # Yaumi
  #...............................
    day =~ /^[ \*]$/        #  
#    day =~ /^[#{@day_OFF}]$/        #
  end

  
  #.................................
  def isOnDay(day)
  #.................................
    day =~ /^[#{@day_ON}]$/i   # XxAaBb   , Dd
  end

  #.................................
  def isOnDayAll(day)     # All OnDay including other Place
  #.................................
    day =~ /^[#{@day_ON_ALL}]$/i   # xabXABD  ,d 
  end

  #...............................
  def isFullOffDay(worker, day) # Koukyu #[-
  #..............................
#[- yet
    @chk_worker[:FullOffDays][worker].include?(day)
    isOffDay(@wrkdays[worker][day] ) && isOffDay(@wrkdays[worker][day -1] )
  end


  #.....................
  def get_theDayOnOff(day)     # status On or Off of All Workers at the Day
  #.....................
    retstr=[]
    (0...@num_workers).each {|w|
      retstr << @wrkdays[w][day]
    }
    retstr
  end #def get_theDayOnOff(day)

  #...........................
  def get_Canididate(day)
  #...........................
    # when the Day is not Filled TEIIIN (under/over)
  #  puts "# def get_Canididate(day)"
    candi = []
    cnt = cnt_filled(day)
    doTimes = (@num_workers_p_day  - cnt)
    (0...@num_workers).each_with_index  {|w, i|
      if doTimes == 0   # filled OK
        break
      else
        theDay = @wrkdays[w][day]   
        if doTimes > 0
        # Under --> find OFF days to ON
          if isOffDay( theDay )
            candi << i
#            doTimes -= 1
          end
        else # doTimes< 0
          # Over --> find ON days to OFF
          if isOnDay( theDay )
            candi << i
#            doTimes += 1
          end
        end
      end
    }
 #   puts "num=#{cnt}   #{@num_workers_p_day  - cnt} times in cand #{candi}" if cnt != 2
    return [ candi, ( @num_workers_p_day  - cnt ).abs ]
  end #  def get_Canididate(day)

  # 
  #..............................
  def start_p( fourDays )
  #.............................
    if isOffDay( fourDays[3] )    # _|
      if isOffDay( fourDays[2] )    #  0 1 2
        p_template=0              ##  __| X X X
      else
        if isOffDay( fourDays[1] )     # _x_| XXX
          p_template=0
        else                    # xx_|
          if isOffDay( fourDays[0] )         ## _xx_| _XXX
            p_template=4
          else
            p_template=4           ## xxx_| _XXX
          end
        end
      end
    else                        # x|
      if isOffDay( fourDays[2] )         # _x|
        if isOffDay( fourDays[1] )          # __x | XX__
          p_tmplate=1
        else                      # x_x |
          if isOffDay( fourDays[0] )
            p_tmplate=2            ## _x_x | X__ or XX_  ... 1
          else
            p_tmplate= 3           ## xx_x | __X or _X_  special
          end
        end
      else                     # xx|
        if isOffDay( fourDays[1] )          # _xx|
          if isOffDay( fourDays[0] )
            p_tmplate= 2            ## __xx | X__ 
          else
            p_tmplate= 2            ## x_xx | X__   or _XXX   
          end
        else                      #  xxx |
          p_tmplate=3               ## xxx | __XXX
        end
      end
    end
  end

  #-----------------------
  def get_SeqOffDays( wkDays )
  #-----------------------  
#  print "#-- def get_SeqOffDays( ", wkDays," ) ---\n"
    #---- start Here -----    
    seqs_pos=[]    # Array of array days Po9q1
    days = []
    num_days = 0  #  Check form Last 4 days of Prev Month
    #  ' ':LastDayOfPrevMonth | ' ': FirstDay  ===> FullOffDay 
#    (0..@num_days16+4).each{|nth_day|
    (0...@num_days16+4).each{|day|
      if  isOffDay( wkDays[day] )
        days << day
        num_days+=1
      else
        if num_days > 1
          seqs_pos << days
        end
        days = []
        num_days=0
      end
    }
    if num_days > 1
      seqs_pos << days
    end
#    print "#-- seq data '", seqs_pos, "'  at set_SeqOffDays\n"
    seqs_pos
  end
  ###

  #----------------------------
  def get_WithFullOffDays( seqs )
  #----------------------------
    #  puts "# def get_FullOffDays( #{seqs} )"
    # ---- In Range of the Month
    daysWithFullOff =[]    # array of seq of OffDays 
    seqs.each do|days|
      #    puts "Check element daary #{days}"
      days_ =[]
      #    puts "# Range #{@theMonthRange}' "
      days.each {|day|
        if @theMonthRange.member?(day)
          days_ << day
        end
      }
      #    puts "## days in seq days_ ==> '#{days_}'"
      #    puts "## days length ==> '#{days_.length}'"
      case days_.length
      when 1
        if days_[0] == 4
          daysWithFullOff << [ days_.shift ]
          #else
          #  month over  
        end
      when 2, 3, 4
        daysWithFullOff << days_  # array of Kokyu
      when 0
        ;
      else    #  3,4,5.....
        daysWithFullOff << days_  # array of Kokyu
      end
      #    puts "## days after removed out of range _ ==> '#{days_}'"
      #    puts "## daysWithFullOff '#{daysWithFullOff}'"
    end
    #
 #     puts "## daysWithFullOff '#{daysWithFullOff}' at get_WithFullOffDays"
    #
    daysWithFullOff
  end 

  #----------------------------
  def get_FullOffDays(worker)
  #----------------------------
#  puts "##-- def get_FullOffDays( #{worker} ) ----" 
 #   print "##  @chk_workers[:WithFullOffDay][worker] '", @chk_workers[:WithFullOffDay][worker], "'\n"

    ary_seqdays = Marshal.load(Marshal.dump( @chk_workers[:WithFullOffDay][worker] ) )
#    ary_seqdays = @chk_workers[:WithFullOffDay][worker].clone
 #   print "dup  ='",  ary_seqdays.object_id, "'\n"
#    print "orig ='", @chk_workers[:WithFullOffDay][worker].object_id, "'\n"
 #   print "##  Array of array seqs (dupped) '", ary_seqdays, "'\n"
    if ary_seqdays.empty?
      @chk_workers[:FullOffDays][worker] = []
      return ary_seqdays
    end
    
    ret=[]
    
#    if ary_seqdays[0].size == 1          #  && ary_seqdays[0][0] == 4
#      ret <<  ary_seqdays[0]
#      ary_seqdays.shift
#    end
      
    ary_seqdays.each {|seqs|
      if seqs.size == 1          #  && ary_seqdays[0][0] == 4
        ret <<  seqs
#        ary_seqdays.shift
      else
        seqs.shift
        ret << seqs
      end
    }
    ret.flatten!
#    print "## @chk_workers[:WithFullOffDay][worker] '", @chk_workwers[:WithFullOffDay][worker], "'\n"
    #    print "##-- get_FullOffDays --'", ret, "'\n"
    @chk_workers[:FullOffDays][worker] = ret
    ret
  end

  #----------
  def get_Score()
  #----------
#  puts "# def get_Score()"
    scr= sprintf( "%02d ", @chk_Place[:OK]*2)
    #puts "## scr : Num of OK in the Month  #{scr} x 2"
    w_scr=0
   # scr=@chk_Place[:OK].to_s.
    (0...@num_workers).each {|w|
    #  puts "#.#{w} KOKYU = #{ @chk_workers[:FullOffDays][w] }"
      w_scr += ( 9 - @chk_workers[:FullOffDays][w].size * 2).abs / 2
    }
    #puts "score (OK x 2) :#{scr}"
    #puts " w_scr ( 9 - kokyu x 2) / 2 ) = #{w_scr}"
    #puts " Total Score  ( score - wscr ) :#{ @chk_Place[:OK]*2 - w_scr}\n"
    @chk_Place[:OK]*2 - w_scr
  end #def get_Score()
  
  #
  #   check & Hyouka
  #
  #..............................
  def examine(workers=[0,1,2,3])
  #...........................
#  puts "# def examine( #{workers} )"
    #
    #  set PLACE Check to @chk_Place
    # -------
    (0...4+@num_days16 ).each{ |day|
      @chk_Place[:numDay][day] = cnt_filled( day )
      @chk_Place[:isOK][day] = ( cnt_filled( day ) == @num_workers_p_day )
      @chk_Place[:dayView][day] = str_Attr ( cnt_filled( day ))
    }

    # between n.16th --> n_1.15th  
#    (4 ... 4+ @num_days16 ).each { |day|
    @chk_Place[:OK] = @chk_Place[:numDay][4, @num_days16].count( 2 )
      #
    @chk_Place[:Under] = @chk_Place[:numDay][4, @num_days16].count( 1 )
    @chk_Place[:Under] += @chk_Place[:numDay][4, @num_days16].count( 0 )
    #
    @chk_Place[:Over] = @chk_Place[:numDay][4, @num_days16].count( 3 )
    @chk_Place[:Over] += @chk_Place[:numDay][4, @num_days16].count( 4 )
    if @chk_Place[:OK] + @chk_Place[:Under] + @chk_Place[:Over] != @num_days16
      puts "############# <<def examine(workers=[0,1,2,3]) >>====="
      puts "# Prog Error "
      puts "##  @chk_Place[:OK] + @chk_Place[:Under] + @chk_Place[:Over] != @num_days16"
      puts "##  #{@chk_Place[:OK]} + #{@chk_Place[:Under]} + #{@chk_Place[:Over]} != #{@num_days16}"
      puts "############# << def examine(workers=[0,1,2,3]) >> ====="
      puts "\a"      # BELL
      exit 1
    end

    # ------
    # set WORKER Check
    #  to @chk_Place
    # -------    
    workers.each do |w|
#      puts " workers = #{w}"  
      @chk_workers[:OffDay][w] = 0
      @chk_workers[:WithFullOffDay][w] = []
      @chk_workers[:OnDay][w] = 0
      @chk_workers[:OnDayAll][w] = 0
      @theMonthRange.each do |day|
        @chk_workers[:OnDay][w] += 1  if isOnDay( @wrkdays[w][day] )
        @chk_workers[:OffDay][w] += 1  if isOffDay( @wrkdays[w][day] )
        @chk_workers[:OnDayAll][w] += 1  if isOnDayAll( @wrkdays[w][day] )
      end
      #      @chk_work0ers[:WithFullOffDays][w] = []   @wrkdays[w])
      @chk_workers[:WithFullOffDay][w] = get_WithFullOffDays( get_SeqOffDays( @wrkdays[w] ) )
      #     print "\n# in exam. No.#{w} '", @chk_workers[:WithFullOffDay][w], "'\n\n"
    end

    puts strStatus_Place()      #[- !!!???
    
    (0..3).each {|w|
#      puts "#----- exam Worker -- #{w}"
      dat = get_FullOffDays(w)
      dat.flatten!
 #     puts  " Full Off Days = #{dat.size} days:    #{dat}"
    }
    
    #.... Save the Best Score
#    chk_BestScore()
  end   # of examine

  def chk_BestScore( point )
  # def save_BestScore
  # def load_BestScore()
  # def   
    if point > @bestScore[:point]
      @bestScore[:point] = point
      @bestScore[:num] = 0
      @bestScore[:case] = [ save_Case( "TieScore" ) ]
      @bestScore[:env] = []   # seq_workers etc
    elsif point == @bestScore[:point]
      @bestScore[:num] += 1
      @bestScore[:case] << save_Case( "TieScore" )
    end

  end #  chk_BestScore( point )

   
  #----------------------------
  def strStatus_Worker(worker)
  #----------------------------
    #  show status of worker
    #  by chk_worker

#    print "# def  strStaus_Worker( #{worker} )\n"

    @statusStr_Worker =  "# No.#{worker}     #{@num_days16}\n"

    dat = get_FullOffDays(worker)
    @statusStr_Worker = @statusStr_Worker + " Off: #{@chk_workers[:OffDay][worker]}  FullOff(休): #{dat.length}  #{dat}\n"
    @statusStr_Worker = @statusStr_Worker + " On: #{@chk_workers[:OnDay][worker]} ['On' with Other Place ]: #{@chk_workers[:OnDayAll][worker]}"

    @statusStr_Worker 
  end
  
  #---------------------
  def strStatus_Place()
  #---------------------
    @statusStr_Place = "#{@num_days16}  = OK: #{@chk_Place[:OK]} +  Under: #{@chk_Place[:Under]} + Over: #{@chk_Place[:Over]}"
    @statusStr_Place
  end
  
  #................................
  def cnt_filled(idx_day, idx_workers=[0, 1, 2, 3])
  #..............................
    # number of current worker Now
    #  must be adjusted to
    #  @num_wokers_p_day
    cnt=0
    idx_workers.each{|w|
      cnt += 1 if isOnDay( @wrkdays[w][idx_day] )
    }
    cnt
  end

  #-----------------------
  def do_ToggleDay(worker, idx_day)
  #-----------------------
  #puts "def do_ToggleDay( #{worker}, #{idx_day} ) "
    done = false
    
    if isOnDay( @wrkdays[ worker ][idx_day] )
      @wrkdays[ worker ][idx_day] = '*'
      done = true
    else
      if isOffDay( @wrkdays[ worker ][idx_day] )
        @wrkdays[ worker ][idx_day] = 'X'
        done = true
      else
        puts "#!! do_ToggleDay UnChangable"
        puts "#!! code '#{@wrkdays[worker][idx_day]}'  (#{worker}, #{idx_day})"
      end
    end
    done
  end  # def act_ToggleOneWorker
  
  
  #----------------------------------------
  def do_Exchange(wrkr1, day1, wrkr2, day2)
  #----------------------------------------
    puts "def do_Exchange(#{wrkr1},  #{day1}, #{wrkr2}, #{day2})"
    isDone = false
    msg="#!!=== do_Exchange ERROR\n"
    # check range
    if !(0...@num_workers).include?( wrkr1 ) or
       !(0...@num_workers).include?( wrkr2 )
      msg+="## worker Error "
    else
      if !@theMonthRange.include?(day1) or
         !@theMonthRange.include?(day2)
        msg+=" DAY Error"
      else
        day_1 = @wrkdays[wrkr1][day1]
        day_2 = @wrkdays[wrkr2][day2]

#    copy_Data( @wrkdays[wrkr1][day1], day_1)
#    copy_Data( @wrkdays[wrkr2][day2], day_2)
    #day_1 = @wrkdays[wrkr1][day]
    #day_2 = @wrkdays[wrkr2][day2]
        if day_1 == 'D' or day_2 == 'D'
          msg += "==== UnChangable VALUE "
        else
          #
          if @debug_do_Exchange
            puts "#==== Before day1 '#{day_1}'   day2 '#{day_2}'"
          end # can_ToggleWorkers(wrker, day)
          #          copy_Data( day_2, @wrkdays[wrkr1][day1])
          #     copy_Data( day_1, @wrkdays[wrkr2][day2])
          @wrkdays[wrkr2][day2]= day_1
          @wrkdays[wrkr1][day1]= day_2

  if @debug_do_Exchange
            puts "#==== After  day1 '#{@wrkdays[wrkr1][day1]}'   day2 '#{@wrkdays[wrkr2][day2]}'"
  end #
#      @wrkdays[wrkr1][day1] = day_2
#      @wrkdays[wrkr2][day2] = day_1
          isDone = true
        end
      end
    end
  end # def do_Exchange(wrkr1, day1, wrkr2, day2)
  
  #.............................
  def set_WorkersSeq( doneWorker )
  #.............................
    if @debug_seq_WorkersSeq     
             puts "# def set_WorkersSeq( #{doneWorker} )"
             puts "# seq=#{@seq_workers} "
    end # if debug_seq_WorkersSeq     
    newData=[]
    @seq_workers.each_with_index { |wrkr, i|
      if doneWorker == wrkr
        newData  += @seq_workers[i+1,99]
        break
      else
        newData << wrkr
      end
    }
    if @debug_seq_WorkersSeq     
             puts "# ret='#{newData}'"
     end ## if debug_seq_WorkersSeq     
    @seq_workers = newData    
  end  #def set_WorkersSeq(  doneWorker )


  #--------
  #  miscellaneous
  #--------

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
  # Story 
  #  prepare, set Yotei
  #  adjustRound
  0. Test Env
  1. all saved # Init
  2. sse saved case # After Koyano
  3. Shift 
  4. Display , # History
  5. Manual Handling
  9. Quit
EOF
    print prompt
    print ' : '
    while true
      l=gets.chop
      case l
      when /^\b*(\d)\b*$/
        menu = l.to_i
        case menu
        when 0
        when 1
          allSavedCase()
        when 2
          allSavedCase()
        when 3
        when 4
        when 5
        when 9
          return 9
          
        end # case menu
      end
    end
    
  end # def sel_MainMenu()
  
  #.........................
  def sel_ToggleExchange(msg=nil)
  #.........................
    puts msg if msg != nil
    prompt=<<-EOF

[ Manual HANDLING ]
 'worker, day':     Toggle On/Off 
 'w1,day1 w2,day2': Exchange 
                     day1 day2
  'M' :    Upper Menu
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
        end
        return ret
      when /^[ \t]*Q/i
        puts "Exit"
        exit 0        
#        break
      when /^[ \t]*M/i
        return 'M'
      end
    end
  end # def sel_ToggleExchange(msg=nil)
  
end  # End of Module
