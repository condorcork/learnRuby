#!/usr/bin/env ruby
# coding: utf-8

require 'date'

Teiin = 2

#......
# 2018-11-02(Fri) 17:35:00
#
# 2018-10-27(Sat) 11:09:36
# 2018-10-27(Sat) 15:27:27
# 10-29(Mon) 15:43
# 10-30(Thu) 13:49
# 2018-10-30(Tue) 18:57:15
##
# Bug: bug, to DO
#-----------------
#  bug
#
#-----------------
#

#  -- set last 4 days of prev month 
#  def prepare(idx, prevdays=' '*4, nvotAvail={})
# 

class Yotei

include './TestHelper'
include './FakeSystem'
include './ControlHelper'
include './View'
  
  # date
  #  @month_16
  #  @year_16 
  #  @num_days16
  #  @wday_16
  #  @theMonthRange  #[- to refact
  # @num_workers
  # ...
  # check
  #  @wrkdays
  #  @cnt_hecks
  
  #............................
  def initialize(members=4, fakeDate=nil )
  #...........................
        # @month_16
    # @num_days16..[28/29/30/31]

    @debug_= 2
#    @debug_ = 3  # 0,1, 2

    if fakeDate != nil
      d=fakeDate.split('-')
      d.map!(&:to_i)
      p d
      date=Date.new(d[0], d[1], d[2])
      puts "tmp Today : #{date.year} #{date.month} #{date.day}\n\t#{date}"
    else
      # Honban
      date=Date.today
      puts "Today : #{date.year} #{date.month} #{date.day}\n\t#{date}"
    end
    #
    init_InitVarCon(members, date)
    #
    init_fake()
  end


  #------------------------
  #  preparation
  #................................
  def presetKoyano(idxWorker, howTo=0) 
    #..............................
    #  howTo : how to Add OnDay
    #         0 : OnDay set to lastday of seq 3 days
    # not only weekly,
    # but for General use
    # suposed already set Dame Days
    
    puts "\n#==  presetKoyano( #{idxWorker} )"

    pos_OffDays = get_SeqOffDays( @wrkdays[idxWorker])   
    p "po_OffDayss",pos_OffDays

    cnt_add = 0
    pos_OffDays.each {|days|
      print "# seq OffDays "; p days
      print "#     OffDays.size "; p days.size
      puts  "#   now stat (Last pos0 = '#{days[-1]}'"
      if days.size > 2
        cnt_add += 1
        # set Last day in OffDay-seq
        if isOnDayAll( @wrkdays[idxWorker][days[-1]] )
          puts "#===== presetKoyano"
          puts "#===LOGICAL ERROR=="
          puts "  #{@wrkdays[idxWorker][days[-1]]}   day #{days[-1]} in #{days}"
          exit
        end
          
        @wrkdays[idxWorker][days[-1]] = 'x'
      end
    }
    puts "#==== presetKoyano #{cnt_add} days Added"

    examine()

  end
  
  #...............................
  def yoyaku(id_worker=3, preserv)
  #...............................
    puts ## def yoyaku( #{id_worker}, #{preserv} )#
    unless id_worker  < @num_workers
      puts "Yoyaku: 1nd param : idx '#{id_worker}' must be less than #{@num_workers.to_s}"
      return false
    end
    #---
    psv=preserv.split('').sort
    all='0123456'.split('')
#----    
    psv=preserv.split('').map(&:to_i)
    
    startDay = Date.new(@year_16, @month_16, 16).day

    i=4
    delta=0
    (startDay..startDay + 30).each {|x|
     yb =( @wday_16 + delta ) % 7
=begin
if @debug_ > 1      
      puts  " Pos Index  i : #{i}"
      p " start day  #{x}"
     puts "Yoybi #{yb}  #{%w(Su Mo Tu We Th Fr Sa)[yb]}"
end
=end
      if psv.include?(yb)
        @wrkdays[id_worker][i] = 'D'
        if @debug_ == -1
          p @wrkdays[id_worker]
        end
      end
      i+=1
      delta+=1
    }
  end

  #............................
#  def pre_set(pass_idx)
  def pre_set(idxs_workers=[0,1,2])
  #..........................
    puts "# def pre_set(#{idxs_workers})"

    idxs_workers.each do |n|
      pre_set_one(n)
    end
  end
    
  #.....................
  def pre_set_one(idx)
  #...................
puts "# def pre_set_one( #{idx} )"

      dat_work=@wrkdays[idx]
      startp=start_p(dat_work)
      i=4;

      for k in startp..34
        dat_work[i]=@template[k]
        i=i+1
      end
      @wrkdays[idx]= dat_work
  end

  #.............................
  def prepare(idx, prevdays=' '*4, nvotAvail={})
    #.............................
    puts "def prepare( #{idx}, #{prevdays}, #{ nvotAvail})"

   # notAvail
    unless idx < @num_workers
      puts "prepare: 1nd param : idx '#{idx}' must be less than #{@num_workers.to_s}"
      return false
    end
    if prevdays.length!=4
      puts "prepare: 2nd param Length Not 4";
      puts "  '#{prevdays}'"
      return false
    end
    #
    prv=prevdays.split('')
  if @debug_ > 10
    p prv
  end
    itm=Array.new
    (0..34).each do |n|
      if n < 4 then
        itm[n]=prv[n]
      else
        itm[n]=' '
      end
    end
    @wrkdays[idx]=itm
    return true
  end


  #
  #   Real Actual Operation 
  #
  #..............................
  def shift_to(idxWorker, direction=+1)
  #..............................
    # shift right +N, left -N
    puts "\n\n#==  def shift_to( #{idxWorker}, #{direction} )"    
    strDays = @wrkdays[idxWorker].join('')
    strDays = strDays.slice(4, @num_days16)
    puts " Orignal 4, @num_days16  strDays  '#{strDays.length}'"
    puts "'#{strDays}'"
    puts "....+....0"*4

    distance = ( direction < 0 ? direction * -1 : direction )
    puts "#--- distance  '#{distance}'"
    filler = ' ' * distance    
    puts "#--- filler "
    puts "'....+....0"*4
    puts "'#{filler}'"
    if direction > 0
      strDays = filler + strDays
      strDays = strDays.slice(0, @num_days16)
    else
      strDays = strDays.slice(distance, 33)  + filler
    end
    strDays = @wrkdays[idxWorker].join('').slice(0,4) + strDays
    @wrkdays[idxWorker] = strDays.split('')
  end

=begin 
# yet perhaps Not So good  
  #..............................
  def shift_Part(idxWorker, direction=+1, idx_Start)
    #..............................
  # shift right +N, left -N
    puts "#  def shift_Part( #{idxWorker}, #{direction} )"    
    #
    strDays = @wrkdays[idxWorker].join('')
    strDays = strDays.slice(idx_Start, @num_days16)
    puts " Orignal 4, @num_days16  strDays  '#{strDays.length}'"
    puts "'#{strDays}'"
    puts "....+....0"*4

    distance = ( direction < 0 ? direction * -1 : direction )
    puts "#--- distance  '#{distance}'"
    filler = ' ' * distance    
    puts "#--- filler "
    puts "'....+....0"*4
    puts "'#{filler}'"
    if direction > 0
      strDays = filler + strDays
      strDays = strDays.slice(0, @num_days16)
    else
      strDays = strDays.slice(distance, 33)  + filler
    end
    strDays = @wrkdays[idxWorker].join('').slice(0,4) + strDays
    @wrkdays[idxWorker] = strDays.split('')
  end # shift_Part
=end
  
  #...........................
  def adjust(worker, reset=true)
  #............................
    puts "\n\n"
    puts "#def adjust( #{worker} )"
    save_Case
    
    cnt_add=cnt_del=changed=cnt_ok = cnt_ok0 =cnt_offDays =  0
    @theMonthRange.each {|day|
      num = cnt_filled(day)
      case num
      when 2
        cnt_ok0 += 1        
      when 1, 0
        if isOffDay( @wrkdays[worker][day] )
          @wrkdays[worker][day] = 'X'
          cnt_add += 1
          changed += 1
        end
      when 3, 4
        if isOnDay( @wrkdays[worker][day] ) 
          @wrkdays[worker][day] = '*'
          cnt_del += 1
          changed += 1
        end
=begin        
      when 0
      when 4
=end
      else
        
      end
      # to  evaluate
      if cnt_filled(day) == 2
         cnt_ok += 1
      end
      if isOffDay(@wrkdays[worker][day] )
        cnt_offDays += 1
      end
    }

    hor_show(worker)  # include exa.

    puts "# RESULT Adjusted"
    puts "# #{changed} days adjusted   On #{cnt_add}  Off #{cnt_del} for Person  #{worker}"
    puts "    OK  Before #{cnt_ok0}  ==> After #{cnt_ok} days  "
    puts "#   Result + #{cnt_ok - cnt_ok0}"
    puts "##  OffDay is #{cnt_offDays} days"

=begin
# 恐ろしいことを    
    p "## Full Off Days"
    @chk_workers[:WithFullOffDay][worker] = get_WithFullOffDays(
      get_SeqOffDays(
        @chk_workers[:WithFullOffDay ][worker]
      )
    )
=end    
    puts strStatus_Worker(worker)
    
    puts strStatus_Place()
    point = get_Score

    if reset
      load_Case
    end
    puts point    
    point
  end #def adjust(worker, reset=true)

  #...........................
  def adjust_RoundXX(workers=[0,1,2,3], reset=true)
  #............................
    #	adjust day by day
    #	proper worker to fill not available day
    
    puts "\n\n"
    puts "#  adjust_Round( #{workers} )"
#    if workers.empty?
#      puts "#!! "
#    else
#    end
#      
      
    save_Case

    p "## workers", workers
    workers=workers*3
    cnt_add = cnt_del = changed = cnt_ok = cnt_ok0 = cnt_offDays =  0
    cnt_days=0
    cnt_change_p_worker=Array.new(@num_workers, 0)
#    wrker = workers[0]
    wrker = workers.shift
    day_start = 4
    doRedo = false
    @theMonthRange.each do |day|
      num = cnt_filled(day)
      puts "##----------Check #{day}   worker #{wrker}   filled  num=#{num}"
      case num
      when 2
        cnt_ok0 += 1        
      when 1,   0   # 0
        p "## Day ",day
        p "## wrker ",  wrker
        p "## @wrkdays[ wrker][day] ", @wrkdays[ wrker][day] 
        if isOffDay( @wrkdays[wrker][day] ) #####
          puts "##   wrker #{wrker}    ' ' -->X "
          @wrkdays[wrker][day] = 'X'
          cnt_add += 1
          changed += 1
          cnt_change_p_worker[wrker] += 1
          wrker = workers.shift
        else
          puts "##   else wrker #{wrker}   "
          avails = can_ToggleWorkers(wrker, day)
          if avails.include?(@Koyano)  # Koyano
            puts "##  Koyano "
            @wrkdays[@Koyano][day] = 'X'
            cnt_add += 1
            changed += 1
            cnt_change_p_worker[ @Koyano ] += 1
          end
        end
        if num ==0
          if ! doRedo 
            redo
          else
            doRedo = false
          end
        end
      when 3,  4
        p "## Day ",day
        p "## wrker ",  wrker
        p "## @wrkdays[ wrker][day] ", @wrkdays[ wrker][day] 
        if isOnDay( @wrkdays[wrker][day] ) 
          @wrkdays[wrker][day] = '*'
          cnt_del += 1
          changed += 1
          cnt_change_p_worker[wrker] += 1
          wrker = workers.shift
        else
          avails = can_ToggleWorkers(wrker, day)
          print "## when 3 to off '",  avails, "'\n"
          case avails.size
          when 0                 # Oteage !!
            next;
          when 1
            worKer= avails[0]
            @wrkdays[worKer][day] = '*'
            cnt_del += 1
            changed += 1
            cnt_change_p_worker[worKer] += 1
          #    Next Jun !?!
          # Next JUN  !?
          # wrker = workers.shift
          when 2   # avails.size
            worKer = avails[0]
            worKer1 = avails[1]
            @wrkdays[worKer][day] = '*'
            cnt_del += 1
            changed += 1
            cnt_change_p_worker[worKer] += 1
            
            # Next JUN  !?
            # wrker = workers.shift
            #
            if num == 4
              @wrkdays[worKer1][day] = '*'
              cnt_del += 1
              changed += 1
              cnt_change_p_worker[worKer1] += 1
              #
              # Next JUN  !?
              # wrker = workers.shift
            end
          when 3   # avails size
            worKers =[]
            # 01230123
            #    3
            #     0123
            #------
            #  1
            # 0 230123
            avails.each {|w|
              if w >= wrker
                worKers << w
                break
              end
            }
            
            worKer = worKers[0]   # avails[0]
            worKer1 = worKers[1]  # avails[1]
            @wrkdays[worKer][day] = '*'
            cnt_del += 1
            changed += 1
            cnt_change_p_worker[worKer] += 1
            workers = set_WorkersSeq( workers,  worKer )
            if num == 4
              @wrkdays[worKer1][day] = '*'
              cnt_del += 1
              changed += 1
              cnt_change_p_worker[worKer1] += 1
              workers = set_WorkersSeq( workers,  worker1 )
            end
          end   # case avails.size
        end  #  if isOnDay( @wrkdays[wrker][day] ) 

=begin        
      when 0, 4
        puts "##  when 0, 4 --> redo"
        
        if ! doRedo 
          redo
        else
          doRedo = false
        end
=end
      end
    end
    #
    puts "# RESULT Adjust_Round done"
#    puts "# #{changed} days adjusted   On #{cnt_add}  Off #{cnt_del} for Person  #{wrker}"
    puts "# OK days  Before #{cnt_ok0}  ==> After #{cnt_ok} "
    puts "#   Result + #{cnt_ok - cnt_ok0}"
    puts "##  OffDay is #{cnt_offDays} days"
#    
    hor_show() # wrker)  # include exa.
    (0...@num_workers).each {|w|
      puts strStatus_Worker(w)
     }
    
    puts strStatus_Place()
    point = get_Score

    if reset
      load_Case
    end
    puts "# point #{point}"
    point
  end #def adjust_Round(workers=[0,1,2,3], reset=true)


  #.....................
  def do_Toggle_ETC( wrkr, day, changed, cnt_add, cnt_del, cnt_change_p_worker)
  #.....................
    puts "#!! do_Tog..Etc  ( #{wrkr} , #{day} )"
    puts "#!!    Now '#{@wrkdays[wrkr][day]}'"
    puts "#!! seq_workers  '#{@seq_workers}'"
    
    wasDayOff =  isOffDay( @wrkdays[wrkr][day] )
    if do_ToggleDay(wrkr , day)
      puts "#!!  done  '#{@wrkdays[wrkr][day]}'"
      changed += 1
      if wasDayOff
        cnt_add += 1
      else
        cnt_del += 1
      end
      #
      set_WorkersSeq(  wrkr )
      puts "#!! seq_workers  '#{@seq_workers}'"

      cnt_change_p_worker[wrkr] += 1
      if cnt_change_p_worker[wrkr] > 3
        puts "#!! #{wrkr} changed 3 times. So Nore More Change"
        @seq_workers.delete( wrkr )
      end
    else              
      puts "#!! adjust_Round Toggle LOGICAL ERROR "
      puts "#!!   day: #{day}  worker #{wrkr} "
      exit 1;
    end
   end # def do_Toggle_ETC
  
#  days_Data =
  #.....................
  def get_DayOnOff(day)
  #.....................
    retstr=[]
    (0...@num_workers).each {|w|
      retstr << @wrkdays[w][day]
    }
    retstr
  end #def get_DayOnOff(day)

  def get_Canididate(day)
    puts "# def get_Canididate(day)"
    candi = []
    cnt = cnt_filled(day)
    doTimes = (2 - cnt)
    (0...@num_workers).each_with_index  {|w, i|
      if doTimes == 0
        break
      else
        theDay = @wrkdays[w][day]
        if doTimes > 0
          if isOffDay( theDay )
            candi << i
#            doTimes -= 1
          end
        else # doTimes< 0
          if isOnDay( theDay )
            candi << i
#            doTimes += 1
          end
        end
      end
    }
    puts "num=#{cnt}   #{2 - cnt} times in cand #{candi}"
    return [ candi, ( 2 -cnt ).abs ]
  end #  def get_Canididate(day)

  
  #-----------------
  def adjust_Round( reset=true)
  #-----------------
    #
    cnt_add = cnt_del = changed = cnt_ok = cnt_ok0 = cnt_offDays =  0
    cnt_days=0
    cnt_change_p_worker=Array.new(@num_workers, 0)

    @theMonthRange.each do |day|
      #     num = cnt_filled(day)
      puts "#=== #{day} ==="
      candiWorkers,cnt_Times =  get_Canididate(day)
      puts "#--- #{cnt_Times} in cand #{candiWorkers}"
 #     isBreak = false
      @seq_workers.each_with_index do |wrkr, seq_idx|
        #       break if isBreak
        break if seq_idx > @num_workers
        if candiWorkers.any?(wrkr)
          do_Toggle_ETC( wrkr, day, changed, cnt_add, cnt_del, cnt_change_p_worker)
          candiWorkers.delete(wrkr)
          cnt_Times -= 1
          if cnt_Times < 1
            break
#            isBreak = true
          end
        end
      end # @seq_workers.each_
    end # @theMonthRange.each do |day|
##    
    puts "# << Adjust_Round done>> "
    puts "# #{changed} days adjusted   On #{cnt_add}  Off #{cnt_del} for Person  #{@seq_workers}"
    puts "# OK days  Before #{cnt_ok0}  ==> After #{cnt_ok} "
    puts "#   Result + #{cnt_ok - cnt_ok0}"
    puts "##  OffDay is #{cnt_offDays} days"
#    
    hor_show() # @seq_workers[0])  # include exa.
    (0...@num_workers).each {|w|
      puts strStatus_Worker(w)
     }
    
    puts strStatus_Place()
    point = get_Score
    if reset
      load_Case
    end
    puts "# point #{point}"
    point
##    
  end #  def adjust_RoundX()

  #....................
  def think(idxWorker) 
  #..........................
    
    puts "#    def think( #{idxWorker} )"
    (4 .. ( @num_days16 + 4) ).each {|day|
##      puts "# think   day #{day}   '#{@wrkdays[ idxWorker][ day ]}'"
=begin
      if cnt_filled(day) < 2 
        puts "# ==> Tar  day #{day}   '#{@wrkdays[ idxWorker][ day ]}'"
      end
=end      
      if cnt_filled(day) < 2 &&  isOffDay( @wrkdays[ idxWorker][ day ] )
        puts " # ...> Tar Tar "
      end
    }
  end #def think(idxWorker) 
  
end  # class
#--- End of Class ---


__END__
      candiWorkers, doTimes = get_Candidates(day)
      # candi widx 
      #  [0]123 0:On needs 1 Off

      #   0123012.. seq_Workers
       seq_w ( 0 1 2 3 0 .)each nextW
         if cnd(1 2 3).any?(nextW)
            use nextW
            cnd.delete(nextW)
            set seq_w

         else # 
         end
       }
            nextW
a         
                
each cw
      #    seq_
=end
=begin
      days_Data = get_DayOnOff(day)
      puts "##..... Check #{day}  worker #{@seq_workers} filled num=#{num} #{days_Data}"
      case num
      when 1, 3    # 0, 4
        # 1, 3 need one day  On Off
        candiWorkers = []
        days_Data.each_with_index{|s, i|
          if num ==1
            if isOnDay( s )
              candiWorkers << i
            end
          else
           if isOffDay( s )
              candiWorkers << i
            end
          end            
        }
        puts "num=#{num} cand #{candiWorkers}"
        case candiWorkers.size
        when 0
          puts "#=== Dame  over   3 changed Worker Exists ???!??"
          puts "#==  change ocuur p Worker = #{cnt_change_p_worker}"
          next;    # Dame !!
        when 1   # unconditionally it
          worKer = candiWorkers[0]
          do_Toggle_ETC( worKer, day, changed, cnt_add, cnt_del, cnt_change_p_worker)
        when 2     # ( @num_workers - 1 )- 1 # last when num = 1 3
          num_ToDo = (2 - num).abs
          @seq_workers.each_with_index {|nextW,i|
            break if num_ToDo == 0
              
            candiWorkers.each {|cw|
              if cw == nextW
                candiWorkers.delete (cw)
                do_Toggle_ETC(nextW, day, changed, cnt_add, cnt_del, cnt_change_p_worker)
                num_ToDo -= 1
                break;
              end
            }
          }
        when 3
          
        when 4
          
        end
      when 0, 4     # need one day On/Off
        # 0, 4 need two days On Off
        p "## Day ",day
        p "## @seq_workers[0] ",  @seq_workers[0]
        p "## @wrkdays[ @seq_workers[0]][day] ", @wrkdays[ @seq_workers[0]][day] 
        if isOffDay( @wrkdays[@seq_workers[0]][day] ) #####
          puts "##   @seq_workers[0] #{@seq_workers[0]}    ' ' -->X "
          @wrkdays[@seq_workers[0]][day] = 'X'
          cnt_add += 1
          changed += 1
          cnt_change_p_worker[@seq_workers[0]] += 1
          @seq_workers[0] = @seq_workers.shift
        else
          puts "##   else @seq_workers[0] #{@seq_workers[0]}   "
          avail = can_ToggleWorkers(@seq_workers[0], day)
          if avail.include?(@Koyano)  # Koyano
            puts "##  Koyano "
            @wrkdays[@Koyano][day] = 'X'
            cnt_add += 1
            changed += 1
            cnt_change_p_worker[ @Koyano ] += 1
          end
        end
      end # case num
