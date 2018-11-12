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
# check value of 
# not use  [@num_workers (for check)][0..34],
#     but   ==> @check_info[:daycheck] 
#     '2' : ok
#     '3' : Err over 
#     '0' : Err under
#     '1' : ''  under
#     
#................
#  Counter of Kuujitu, Kinmu
#   @check_info{}
#       :ake    [0...@num_workers]
#       :kokyu  [0...@num_workers]
#       :kinmu  [0...@num_workers]
#       :day    [0...31+4]
#       :daycheck  [0..31+4]
#       :dayview   [0..31+4]
#................
  $onDay = 'x'
  $offDat = ' '
  $reserved = 'D'


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
=begin    
#    @check_info=Hash.new()
#    #  Worker Check
    
#    @check_info[:OnDay]=[0...@num_workers]
#    @check_info[:OnDayAll]=[0...@num_workers]
#    @check_info[:OffDay]=[0...@num_workers]
#    @check_info[:FullOffDay]=[0...@num_workers]

#    #  Place check  
#    @check_info[:day]=[0...@num_workers]
#    @check_info[:daycheck]=[0...31+4]
#    @check_info[:isOK]=[0...31+4]
=end
 
    ## status  for each worker
    @chk_workers={}
    @chk_workers[:OnDay]=Array.new( @num_workers )
    @chk_workers[:OnDayAll]=Array.new( @num_workers )   # including workdays of other places 
    @chk_workers[:OffDay]=Array.new( @num_workers )
    @chk_workers[:FullOffDay]=Array.new( @num_workers )
    p @chk_workers
    ## status for Each day 
    @chk_Place = {}
    @chk_Place[:numDay]=Array.new( 31+4 )
    @chk_Place[:isOK]=Array.new( 31+4 )
    p @chk_Place
    # for View ( show )
    @chk_Place[:dayView]=Array.new( 31+4 )
#    p @chk_Place
#    exit 1; 

    
#    @chk_worke
    ##
    #
####    @check_info[:dayview]=[0...31+4]
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
  #..................................
  def isOffDay(day)   # Yaumi
  #.................................
#    day =~ /^[ \*]$/        #  
    day =~ /^[#{@day_OFF}]$/        #
  end

  #..................................
  def isFullOffDay(day)  # Koukyu #[-
  #..................................
#
  end
  
  #.................................
  def isOnDay(day)
  #.................................
    day =~ /^#[#{@day_ON}]$/i   # XxAaBb   , Dd
  end

  #.................................
  def isOnDayAll(day)     # All OnDay including other Place
  #.................................
    day =~ /^#[#{@day_ON_ALL}]$/i   # xabdABD
  end

  def isFullOffDay(idx, day)
#[-    
  end

  
  # 
  #.................................................
  def start_p( fourDays )
    #.................................................
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

=begin  
# Not Used ; 
  #...........................
  def stat_day(idx_day, chk_members=[0,1,2,3], views=false)
  #...........................
    ret=[]
    #    (0...@num_workers).each {|x|
    chk_members.each {|x|
      ret.push @wrkdays[x][idx_day]
    } 
    ret
  end
=end
  
  #............................... 
  def sr_offdays_array(idxWorker)
  #...............................
    seqs_pos=[]
    num_seq=0

    (1...@num_days16+4).each{|nth_day|
#      if @wrkdays[idxWorker][nth_day]==' '
      if isOffDay( @wrkdays[idxWorker][nth_day] )
        num_seq+=1
      else
        if num_seq > 1
          seqs=(0...num_seq).map {|n|
            nth_day - n - 1
          }.sort
          print "seqs '",  seqs, "'\n"
          seqs_pos << seqs
          num_seq=0
        end
      end
    }
    print "#... Off Seq ";seqs_pos
    seqs_pos
  end

=begin  
  #.............................
# yet  def add_OffDays(idxWorker, pos_OffDays)
  #.............................
    pos_OffDays.each {|offDays|
      offDays.each_with_index {|day, i|
        if cnt_filled(day) < 2
          @wrkdays[idxWorker][day] = 'x'
          offDays.delete_at(i)
        end
      }
    }
    p pos_OffDays
  end
=end
  
  #................................
  def cnt_filled(idx_day, idx_workers=[0, 1, 2, 3])
  #................................
    # number of current worker Now
    #    must be adjusted to @num_wokers_p_day
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

end

