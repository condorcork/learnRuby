#!/usr/bin/env ruby
# coding: utf-8

require 'date'

#......
# Bug: bug, to DO
#-----------------
#  bug
#
#-----------------
#

class Yotei

include './TestHelper'
include './FakeSystem'
include './ControlHelper'
include './MenuIo'
include './View'
  
  # date
  #  @month_16
  #  @year_16 
  #  @num_days16  #  @wday_16
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

# ---- Test DATE --------
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
    init_View
  end

  #[- Yet
  def changeParam( param )  # changeParam( :template, : )
    puts "# def changeParam( param )"
    
    # date
    #  template
    #  seq_workers : start 0, 1 ,2 3
  end #def changeParam( param )

  
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
 #   p "po_OffDayss",pos_OffDays

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
    puts "# presetKoyano #{cnt_add} days Added"
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
  def put_Patterns(idxs_workers=[0,1,2])
  #..........................
    puts "# def put_Patterns( #{idxs_workers} )"

    idxs_workers.each do |n|
      put_Pattern(n)
    end
  end # puts_Patterns
    
  #.....................
  def put_Pattern(idx)
  #...................
    puts "# def put_Pattern( #{idx} )"

      dat_work=@wrkdays[idx]
      startp=start_p(dat_work)
      i=4;

      for k in startp..34
        dat_work[i]=@template[k]
        i=i+1
      end
      @wrkdays[idx]= dat_work
  end # put_Pattern

  #.............................
  def prepare(idx, prevdays=' '*4, nvotAvail={})
  #.............................
#    puts "def prepare( #{idx}, #{prevdays}, #{ nvotAvail})"

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
  #  puts " Orignal 4, @num_days16  strDays  '#{strDays.length}'"
  #  puts "'#{strDays}'"
    puts "....+....0"*4

    distance = ( direction < 0 ? direction * -1 : direction )
#    puts "#--- distance  '#{distance}'"
    filler = ' ' * distance    
#    puts "#--- filler "
#    puts "'....+....0"*4
#    puts "'#{filler}'"
    if direction > 0
      strDays = filler + strDays
      strDays = strDays.slice(0, @num_days16)
    else
      strDays = strDays.slice(distance, 33)  + filler
    end
    strDays = @wrkdays[idxWorker].join('').slice(0,4) + strDays
    @wrkdays[idxWorker] = strDays.split('')
  end

#=begin 
# yet perhaps Not So good  
  #..............................
#  def shift_Part(idxWorker, direction=+1, idx_Start, idx_End, filler=' ')
  def slide_Part(idxWorker, direction=1, idx_Start=4, idx_End)  #   , filler=' ')
  #..............................
  # shift or Slide  right +N, left -N from idx_Start to idx_End 
    puts "#  def shift_Part( #{idxWorker}, #{direction},  #{idx_Start}, #{idx_End} )"    
    #
    strDays = @wrkdays[idxWorker].join('')
    strDays = '0123456789|0123456789|'*2
    strDays = strDays.slice(0... 4 + @num_days16 )
    part2 = strDays.slice(idx_Start .. idx_End)
    part1 = strDays.slice(0... idx_Start)
    part3 =  strDays.slice(idx_End + 1 ... @num_days16 + 4)
    
    puts " Orignal "
    puts "'#{strDays}'"
    puts "'" +"....+....0"*4
    puts "'#{part1}'"
    puts "'" + ' '*(idx_Start -1 - 1) + "'#{part2}'"
    puts " " + ' '*( idx_End - 1 - 1 ) + "'#{part3}'"
    puts "'" +"012345678|"*4
return    
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
#=end
  
  #...........................
  def adjust(worker, reset=true)
  #............................
    puts "#def adjust( #{worker} )"
#    save_Case
    cnt_add=cnt_del=changed=cnt_ok = cnt_ok0 =cnt_offDays =  0
    @theMonthRange.each {|day|
      num = cnt_filled(day)
      case num
      when 2
        cnt_ok0 += 1        
      when 1, 0         #[- when 0 More? 
        if isOffDay( @wrkdays[worker][day] )
          @wrkdays[worker][day] = 'X'
          cnt_add += 1
          changed += 1
        end
      when 3, 4         #[- when 4 More?
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

    hor_show() 

    puts "?# RESULT Adjusted"
    puts "?# #{changed} days adjusted   On #{cnt_add}  Off #{cnt_del} for Person  #{worker}"
    puts "?    OK  Before #{cnt_ok0}  ==> After #{cnt_ok} days  "
    puts "?#   Result + #{cnt_ok - cnt_ok0}"
    puts "?##  OffDay is #{cnt_offDays} days"

=begin
# 恐ろしいことを    
    p "## Full Off Days"
    @chk_workers[:WithFullOffDay][worker] = get_WithFullOffDays(
      get_SeqOffDays(
        @chk_workers[:WithFullOffDay ][worker]
      )
    )
=end
    point = show_Result
    if reset
      @wrkdays = load_Case
    end
#    puts point    
    point
  end #def adjust(worker, reset=true)

  #.....................
  def do_Toggle_ETC( wrkr, day, changed, cnt_add, cnt_del, cnt_change_p_worker)
  #.....................
#    puts "#!! do_Tog..Etc  ( #{wrkr} , #{day} )"
#    puts "#!!    Now '#{@wrkdays[wrkr][day]}'"
#    puts "#!! seq_workers  '#{@seq_workers}'"
    
    wasDayOff =  isOffDay( @wrkdays[wrkr][day] )
    if do_ToggleDay(wrkr , day)
#      puts "#!!  done  '#{@wrkdays[wrkr][day]}'"
      changed += 1
      if wasDayOff
        cnt_add += 1
      else
        cnt_del += 1
      end
      #
      set_WorkersSeq(  wrkr )
#      puts "#!! seq_workers  '#{@seq_workers}'"

      cnt_change_p_worker[wrkr] += 1
      if cnt_change_p_worker[wrkr] > @limit_change
        puts "#=== #{wrkr} changed #{@limit_change} times. So Nore More Change"
        @seq_workers.delete( wrkr )
      end
    else              
      puts "#===!! adjust_Round Toggle LOGICAL ERROR (in do_Toggle_ETC"
      puts "#===!!   day: #{day}  worker #{wrkr} "
      exit 1;
    end
   end # def do_Toggle_ETC
  
#  days_Data =
  
  #-----------------
  def adjust_Round( reset=true)
  #-----------------
    #
    cnt_add = cnt_del = changed = cnt_ok = cnt_ok0 =  0
    cnt_change_p_worker=Array.new(@num_workers, 0)

    # Save Before num of OK 
    @theMonthRange.each do |day|
      if cnt_filled( day ) == @num_workers_p_day
        cnt_ok0 += 1
      end
    end
    notfilled = @num_days16 - cnt_ok0
    @limit_change = notfilled / @num_workers
    
    @theMonthRange.each do |day|
      #     num = cnt_filled(day)
 if @debug_adjust_Round       
              puts "#=== #{day} ==="
 end # debug_adjust_Round       
      candiWorkers,cnt_Times =  get_Canididate(day)
 if @debug_adjust_Round       
              puts "#--- #{cnt_Times} in cand #{candiWorkers}" if cnt_Times > 0
 end
#     isBreak = false
      @seq_workers.each_with_index do |wrkr, seq_idx|
        #       break if isBreak
        break if seq_idx > @num_workers
        if candiWorkers.any?(wrkr)
          #
#          do_Toggle_ETC( wrkr, day, changed, cnt_add, cnt_del, cnt_change_p_worker)
          wasDayOff =  isOffDay( @wrkdays[wrkr][day] )
          if do_ToggleDay(wrkr , day)
            #      puts "#!!  done  '#{@wrkdays[wrkr][day]}'"
            changed += 1
            if wasDayOff
              cnt_add += 1
            else
              cnt_del += 1
            end
            #
            set_WorkersSeq(  wrkr )
            cnt_change_p_worker[wrkr] += 1
            if cnt_change_p_worker[wrkr] > @limit_change
              puts "#==!!!= #{wrkr} changed #{@limit_change} times. So Nore More Change"
              @seq_workers.delete( wrkr )
            end
          else              
            puts "#===!! adjust_Round Toggle LOGICAL ERROR (in do_Toggle_ETC"
            puts "#===!!   day: #{day}  worker #{wrkr} "
            exit 1;
          end
          #
          candiWorkers.delete(wrkr)
          cnt_Times -= 1
          if cnt_Times < 1
            break
#            isBreak = true
          end
        end
      end # @seq_workers.each_
      if cnt_filled( day ) == @num_workers_p_day
        cnt_ok += 1
      end
    end # @theMonthRange.each do |day|
    ##
    
#    
    hor_show() # @seq_workers[0])  # include exa.
    #
    puts "# << Adjust_Round done>> "
    puts "# #{changed} days adjusted   On #{cnt_add}  Off #{cnt_del}"
    puts "# Seq_worker  #{@seq_workers}"
    puts "# OK days  Before #{cnt_ok0}  ==> After #{cnt_ok} "
    puts "#   Result + #{cnt_ok - cnt_ok0}"
    
#    point = show_Result()
    if reset
      load_Case
    end
    get_Score
    ##
  end #  def adjust_Round()

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
