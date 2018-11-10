module ControlHelper

  #
# [0.. @num_workers + 1(for check)][0..34]
# [0.. @num_workers][0..34]
#     ' ' : free
#     'x' : kinmu
#     'D' : Dame (antherplace Kinmu)
#     'u' : Zantei temp kinmu           # changable
#     'y','Y' : Yukyu
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

  #----- Initailze -------  
  def init_InstVars(members, teiin, month=nil)
    @numWorkersInPlace = teiin
    @numofWorkersInPlace = members
#    @month ||=  
#      @foo ||= "bar"    'or equal'
      
  end
  
  # 
  #.................................................
  def start_p(yti)
    #.................................................
    if yti[3] == ' ' then    # _|
      if yti[2] == ' ' then    #  0 1 2
        p_template=0              ##  __| X X X
      else
        if yti[1] == ' '        # _x_| XXX
          p_template=0
        else                    # xx_|
          if yti[0] == ' '         ## _xx_| _XXX
            p_template=4
          else
            p_template=4           ## xxx_| _XXX
          end
        end
      end
    else                     # x|
      if yti[2] == ' '         # _x|
        if yti[1] == ' '          # __x | XX__
          p_tmplate=1
        else                      # x_x |
          if yti[0] == ' '
            p_tmplate=2            ## _x_x | X__ or XX_  ... 1
          else
            p_tmplate= 3           ## xx_x | __X or _X_  special
          end
        end
      else                     # xx|
        if yti[1] == ' '          # _xx|
          if yti[0]==' '
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

  #............................... 
  def sr_offdays_array(idxWorker)
  #...............................
    seqs_pos=[]
    num_seq=0

    (1...@num_days16+4).each{|nth_day|
      if @wrkdays[idxWorker][nth_day]==' '
        num_seq+=1
      else
        if num_seq > 1
          seqs=(0...num_seq).map {|n|
            nth_day - n - 1
          }.sort
#          p "seqs"
#          p seqs
          seqs_pos << seqs
          num_seq=0
        end
      end
    }
    print "#... Off Seq ";seqs_pos
    seqs_pos
  end

  #.............................
  def add_OffDays(idxWorker, pos_OffDays)
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

  #................................
  def cnt_filled(idx_day, idx_workers=[0, 1, 2])
  #................................
    cnt=0
    idx_workers.each{|w|
##=begin when isDayOff is corrected
##      if ! isDayOff(w, idx_day )
##        cnt+=1
##      end
##=end
      
     case @wrkdays[w][idx_day]
 #     when ' ', '*'  # 'D',  'y', 'Y'
 #       ;
      when 'x','X'
#      else    # 'x' 'X'
        cnt+=1
      end
    }
    cnt
  end

  #................................
  def isDayOff(idxWorker, day)
  #   return is 'the Day is OffDay'
  #................................
#puts "#    def isDayOff(#{idxWorker}, #{day})"
    case @wrkdays[idxWorker] [ day ]
    when'x', 'X'     #  OnDay ,   'D' is   
      false
    when 'D'
      false #[-
    else # ' '
      true
    end
  end


  #--------
  #  miscellaneous
  #--------

  def are_you_ok?(prompt='ok ? [y|n]:')
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

