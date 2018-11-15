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
    #  view and control # separate?!
    #   @viewsdays=Array.new( @num_workers + 1, Array.new(35, ' ') )
    #   @cnt_checks=Array.new( @num_workers - 1, Array.new(2, 0) )


    # === Working Data ===    
    @wrkdays=Array.new( @num_workers + 1, Array.new(35, ' ') )
    
    # === Data ====
    # check info & views
 
    ## status  for each worker
    @chk_workers={}
    @chk_workers[:OnDay]=Array.new( @num_workers )
    @chk_workers[:OnDayAll]=Array.new( @num_workers )   # including workdays of other places 
    @chk_workers[:OffDay]=Array.new( @num_workers )
    #   for view
    @chk_workers[:FullOffDay]=Array.new( @num_workers )

    ## status for Each day 
    @chk_Place = {}
    @chk_Place[:numDay]=Array.new( 31+4, 0 )
    @chk_Place[:isOK]=Array.new( 31+4 , false)
    #    for View ( show )
    @chk_Place[:dayView]=Array.new( 31+4, ' ' )
    #
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

  #...............................
  def isFullOffDay(day) # Koukyu #[-
  #..............................
#[-
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
    #---- start Here -----    
    seqs_pos=[]    # Array of array days Po9q1
    days = []
    num_days = 0  #  Check form Last 4 days of Prev Month
    #  ' ':LastDayogPrevMonth | ' ': FirstDay  ===> FullOffDay 
    (0..@num_days16+4).each{|nth_day|
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
    seqs_pos
  end
  ###

  def get_WithFullOffDays( seqs )
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
    #  puts "## daysWithFullOff '#{daysWithFullOff}'"
    #  p #{daysWithFullOff}
    daysWithFullOff
  end 

  #
  #   check & Hyouka
  #
  #..............................
  def examine(workers=[0,1,2,3])
    #..............................
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
#      exit 1
    end
    # ------
    # set WORKER Check
    #  to @chk_Place
    # -------    
    workers.each do |w|
#      puts " workers = #{w}"  
      @chk_workers[:OffDay][w] = 0
      @chk_workers[:FullOffDay][w] = []
      @chk_workers[:OnDay][w] = 0
      @chk_workers[:OnDayAll][w] = 0
      @theMonthRange.each do |day|
        @chk_workers[:OnDay][w] += 1  if isOnDay( @wrkdays[w][day] )
        @chk_workers[:OffDay][w] += 1  if isOffDay( @wrkdays[w][day] )
        @chk_workers[:OnDayAll][w] += 1  if isOnDayAll( @wrkdays[w][day] )
      end
      #      @chk_work0ers[:FullOffDays][w] = []   @wrkdays[w])
      @chk_workers[:FullOffDay][w] = get_WithFullOffDays( get_SeqOffDays( @wrkdays[w] ) )
##      print "\n#Full Off No.#{w}  '", @chk_workers[:FullOffDay][w], "'\n\n"      
    end
  end   # of exsmine


  #----------------------------
  def get_FullOffDays(worker)
  #----------------------------
    #  return Array of Full Off Days
    ary_seqdays = @chk_workers[:FullOffDay][worker].dup
    ret=[]
    
    if arypdays[0].size == 1 && arypdays[0][0] == 4
      ret <<  arypdays[0][0]
      arydays.shift
    end
      
    arypdays.each {|seqs|
      seqs.shift
      ret << seqs
    }
    ret
  end
  
  #----------------------------
  def strStatus_Worker(worker)
  #----------------------------
    #  show status of worker
    #  by chk_worker 
    @statusStr_Worker =  "# No.#{worker}     #{@num_days16}\n"
    @statusStr_Worker += " Off: #{@chk_workers[:OffDay][worker]}  FullOff(公休): #{@chk_workers[:FullOffDay][worker]}\n"
    @statusStr_Worker += " On: #{@chk_workers[:OnDay][worker]} [ 'On' with Other Place ]: #{@chk_workers[:OnDayAll][worker]}"
  end
  
  #-----------------------
  def strStatus_Place()
  #-----------------------
    @statusStr_Place = "#{@num_days16}  = OK: #{@chk_Place[:OK]} +  Under: #{@chk_Place[:Under]} + Over: #{@chk_Place[:Over]}"
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
  def are_you_ok?(prompt='ok ? [y|n]:')
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

end  # End of Module
