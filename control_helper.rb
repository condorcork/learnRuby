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
    #--- Constant ----
    @num_workers = members
    @num_workers_p_day = 2            # Teiin
    #
    @template=('xxx  '*8).split('')
#    @template=('xxxx  '*7).split('')
#    @template=('xxx  xx '*5).split('')
#    @template=('xxxxx  '*6).split('')
    ### !!! TO DO : changable  'xxxx  ', 'xxx  xx '
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
    @num_wokers_p_day = 2
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
    
  end
  
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
    @day_ON = 'XAB'
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


  ###
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
    (0...@num_days16+4).each{|nth_day|
      if  isOffDay( wkDays[nth_day] )
        days << nth_day
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
      puts "## daysWithFullOff '#{daysWithFullOff}' at get_WithFullOffDays"
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

  #..............
  def can_ToggleWorkers(wrker, day)
  #..............
    puts "def can_ToggleWorkers( #{wrker}, #{day} )"
    print "wrker #{wrker} '#{ @wrkdays[wrker][day] }'   isOnDay? #{ isOnDay(@wrkdays[wrker][day]) }\n"
    workers_CAN=[]
    (0...@num_workers).each {|w|
      print "  w (0.. #{@num_worker} #{w} "
#      if w != wrker 
      print "    dayis='#{ @wrkdays[w][day] }'   isOnDay? #{ isOnDay(@wrkdays[wrker][day]) }\n"
      print "    isOff(@..[w][day]) =#{isOffDay(@wrkdays[w][day])}   isOn(@..[w][day]) =#{isOnDay(@wrkdays[w][day])}"

      if isOnDay(@wrkdays[wrker][day])
        if isOffDay(@wrkdays[w][day])
          workers_CAN << w
          puts "=== To toggle to On  #{w}"
        end
      else
        if isOffDay(@wrkdays[wrker][day])
          if isOnDay(@wrkdays[w][day])
            puts "=== To toggle for Off  #{w}"
            workers_CAN << w
          end
        end
      end
#      end
    }
    puts "#==== can_ToggleWorkers return #{workers_CAN}"
    workers_CAN
  end # def can_ToggleWorkers

  #............
  def get_CAN(candiWorkers, changed)
  #............
#    candiWorkers.
    if candiWorkers.include?( @Koyano )    # KOYANO SPECIAL
      @Koyano
#    else
#      changed.min
      #
    else
      puts "#!! get_CAN(candiWorkers, changed)"
      puts "#!! get_CAN( #{candiWorkers}, #{changed} )"
      puts "#!! YET NOT MADE !! "
      exit 1
    end
    
  end # def get_CAN()
  
  #----------
  def get_Score()
  #----------
  puts "# def get_Score()"
    scr= sprintf( "%02d ", @chk_Place[:OK]*2)
    puts "## scr : Num of OK in the Month  #{scr} x 2"
    w_scr=0
   # scr=@chk_Place[:OK].to_s.
    (0...@num_workers).each {|w|
      puts "#.#{w} KOKYU = #{ @chk_workers[:FullOffDays][w] }"
      w_scr += ( 9 - @chk_workers[:FullOffDays][w].size * 2).abs / 2
    }
    puts "score (OK x 2) :#{scr}"
    puts " w_scr ( 9 - kokyu x 2) / 2 ) = #{w_scr}"
    puts " Total Score  ( score - wscr ) :#{ @chk_Place[:OK]*2 - w_scr}\n"
    @chk_Place[:OK]*2 - w_scr

  end #def get_Score()
  
  #
  #   check & Hyouka
  #
  #..............................
  def examine(workers=[0,1,2,3])
  #...........................
      puts "# def examine( #{workers} )"
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
      puts "\a"      # BELLx
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

#    puts "#---- exam Place ------"
    puts strStatus_Place()
    
    (0..3).each {|w|
#      puts "#----- exam Worker -- #{w}"
      dat = get_FullOffDays(w)
      dat.flatten!
 #     puts  " Full Off Days = #{dat.size} days:    #{dat}"
    }
  end   # of examine

  
  #----------------------------
  def strStatus_Worker(worker)
  #----------------------------
    #  show status of worker
    #  by chk_worker

#    print "# def  strStaus_Worker( #{worker} )\n"

    @statusStr_Worker =  "# No.#{worker}     #{@num_days16}\n"

=begin    
    @statusStr_Worker += " Off: #{@chk_workers[:OffDay][worker]}  FullOff(公休): #{dat.length} [ #{dat} ] \n"
    @statusStr_Worker += " On: #{@chk_workers[:OnDay][worker]} [ 'On' with Other Place ]: #{@chk_workers[:OnDayAll][worker]}"
=end
    
    dat = get_FullOffDays(worker)

    @statusStr_Worker = @statusStr_Worker + " Off: #{@chk_workers[:OffDay][worker]}  FullOff(休): #{dat.length}  #{dat}\n"
    @statusStr_Worker = @statusStr_Worker + " On: #{@chk_workers[:OnDay][worker]} ['On' with Other Place ]: #{@chk_workers[:OnDayAll][worker]}"

    @statusStr_Worker    

  end
  
  #-----------------------
  def strStatus_Place()
  #-----------------------
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
  
  #--------
  #  miscellaneous
  #--------
# yet   
  #.............................
  def getData(prompt=':Quit/ ')
    #.............................
    if prompt[-1] == "\n"
      prompt.chop!
    end
    if prompt =~ /:([A-Z])/
      rep=[]
      n=1
#      while "$#{n}"
#        
#      end
      while true
        res = gets
        break
      end
    end
  end

  #.............................
  def ok_YN?(prompt='continue ? [y|n]:')
  #.............................
    while true
      print prompt
      res = gets
      case res
      when /^[yY]/
        return true
      when /^[nN]/, /^$/
        return false
      end
    end	
  end

  #-----------------------
  def act_ToggleOneWorker(worker, idx_day)
  #-----------------------
    done = false
    if isOnDay( @wrkdays[ worker ][idx_day] )
      @wrkdays[ worker ][idx_day] = '*'
      done = true
    else
      if isOffDay( @wrkdays[ worker ][idx_day] )
        @wrkdays[ worker ][idx_day] = 'X'
        done = true
      else
        puts "# !! act_ToggleOneWorker unchangable"
        puts "# !!  code = '#{@wrkdays[worker][idx_day]}'"
      end
    end
    done
  end  # def act_ToggleOneWorker

  
  #.........................
  def sel_ToggleOneWorker(msg=nil)
  #.........................
    puts msg if msg != nil
    prompt="Enter 'workmanNo.(0~) date(4~)[]' (index)\n To Toggle On/Off\n eg. '1 10' :"
    print prompt
    ret=[]
    while true
      l=gets
      if l=~/(\d)[ \t]+(\d+)/
        ret[0]=$1.to_i
        ret[1]=$2.to_i
        return ret
      end
    end 
  end # def select_Tog..OneWorker

  #.............................................
  def set_WorkersSeq( seq_workers,  doneWorker )
  #.............................................
    puts "# def set_WorkersSeq( seq_workers,  doneWorker )"
    newData=[]
    seq_workers.each_with_index { |wrk, i|
      if doneWorker == wrk
        newData  += seq_workers[i+1,99]
        break
      else
        newData << wrk
      end
    }
    newData
  end  #def set_WorkersSeq( seq_workers,  doneWorker )


=begin
  def change_IO(prompt=nil)
    if prompt == nil
      prompt="Enter 'workmanNo.(0~) date(4~)[]' (index)\n To Toggle On/Off\n eg. '1 10' :"
      a="Select MENU\n"
      b=" 1:  Toggle On/Off a day "
      c="Exchange On/Off day"
      d=" 2: one Day with Another Day in ONE WORKER"
      e=" 3: one On/Off Day with Off/On Day between 2  WORKERs"
      prompt0=a+"\n"+b+"\n"+c+"\n"+d+"\n"+e
    end
    print prompt0    ret=[]
    while true
      l=gets
      if l=~/(\d)[ \t]+(\d+)/
        ret[0]=$1.to_i
        ret[1]=$2.to_i
        return ret
      end
    end 
  end #def change_IO
=end

  @bestScore = {}
  @bestScore[:scre] = 0
  @bestScore[:check] = ' '
  @bestScore[:data] = 'NIL'
  
=begin
  def BestScore( score, 
    if score > @bestScore[:score]
      @bestScore[:score] = score
      @bestScore[:check] = status_Str_Place #+ 
      @bestScore[:data] = marshal.sump( @wrkdays )
    elsif
      if @bestScore[:check].to_a?(STring)
        @bestScore[:check] = [ @bestScore[:check] ]
        @bestScore[:check] << 
         @bestScore[:data] = marshal.sump( @wrkdays )
      se
      
  @bestScore[:data] = ' '

          @bestScore[:scre] = 
  @bestScore[:check] = ' '
  @bestScore[:data] = ' '
=end
  
end  # End of Module
