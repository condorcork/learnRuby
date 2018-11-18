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
#    presetMultiWorker(me
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
    
    puts "#  presetKoyano( #{idxWorker} )"

    #[-    #... Search consequent ' '
    daysWithOffday = get_SeqOffDays( @wrkdays[idxWorker])   
#[-    @chk_workers[:FullOffDay][idxWorker] = get_WithFullOffDays( daysWithOffday )

    pos_OffDays = daysWithOffday
    
    p "po_OffDayss",pos_OffDays

    cnt_add = 0
    pos_OffDays.each {|days|
      print "# seq OffDays "; p days
      print "#     OffDays.size "; p days.size
      puts  "#   now stat (Last pos0 = '#{days[-1]}'"
      if days.size > 2
        cnt_add += 1
        # set 3rd day in OffDay-seq
#        puts  "#  Before Value  ==> '#{wrkdays[idxWorker][days[-1]]}'"
        @wrkdays[idxWorker][days[-1]] = 'x'
#        puts  "#  AFTER  Value  ==> '#{wrkdays[idxWorker][days[-1]]}'"
      end
    }
    puts "#==== presetKoyano #{cnt_add} days Added"

    examine()

  end
  
  #...............................
  def yoyaku(id_worker=3, preserv)
  #...............................
    puts ## def yoyaku( #{id_worker}, #{preserv} )#
if @debug_ > 10
    p @wday_16
    p " @wday_16", @wday_16.is_a?(Integer)   #  + 1
end
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
if @debug_ > 10
puts "-----  ---------------------"
      puts "Pre_set_one #{idx}th worker '#{@wrkdays[idx]}'"
      puts "startp  #{startp}"
puts "--------------------------"

end
      i=4;

      for k in startp..34
        dat_work[i]=@template[k]
if @debug_ > 10
        p  k, i  
        puts ".... @template[k] #{k} ==> '#{@template[k]}'"
        puts "...... dat_work[i] #{i}            '#{dat_work[i]}'"
        p dat_work
end        
        i=i+1
      end
      @wrkdays[idx]= dat_work
if @debug_ > 10
  puts "--------------------------"
  puts "Dat_Work '#{dat_work}'"
  puts "--------------------------"
  ver_show(idx)
  puts "--------------------------"
#  puts "PreSet @wrkdays[idx]:  #{idx}=>'#{@wrkdays[idx]}'"
  puts "---END of PreSet_one -----------------------"
end
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
    puts "#  def shift_to( #{idxWorker}, #{direction} )"    
    strDays = @wrkdays[idxWorker].join('')
    strDays = strDays.slice(4, @num_days16)
    puts " Orignal 4, @num_days16  strDays  '#{strDays.length}'"
#----- Bug ( debuged ) ------------------------
# syntax error, unexpected keyword_end, expecting tSTRING_DEND (SyntaxError)
#  end
#  ^~~
    #    puts "'#{strDay' }"               # !! Carefully !!
#--------------------------    
    puts "'#{strDays}'"
    puts "....+....0"*4

    distance = ( direction < 0 ? direction * -1 : direction )
    puts "#--- distance  '#{distance}'"
    filler = ' ' * distance    
    puts "#--- filler "
    puts "'....+....0"*4
    puts "'#{filler}'"
    if direction > 0
#      puts "#--- strDays.slice(distance, 100)    "
#      puts "#----'" + "....+....0"*4
#      puts "#--- '#{strDays}'   len=#{strDays.length}"
      strDays = filler + strDays
#      puts "#--- strDays = filler + strDays"
#      puts "#--- '#{strDays}'   len=#{strDays.length}"
      strDays = strDays.slice(0, @num_days16)
#      puts "#=== strDays = strDays.slice(0, @num_days16)"
#      puts "#----'" + "....+....0"*4
#      puts "#--- '#{strDays}'   len=#{strDays.length}"
    else
      strDays = strDays.slice(distance, 33)  + filler
    end
    strDays = @wrkdays[idxWorker].join('').slice(0,4) + strDays
    @wrkdays[idxWorker] = strDays.split('')
  end

  #..............................
  def shift_AI(idxWorker, direction=+1)
    #..............................
  # shift right +N, left -N
    puts "#  def shift_to( #{idxWorker}, #{direction} )"    
    #
    shift_to(idx, dir)
    prev = saveCase
    #   others = (0...@num_workers).to_a - [ idx ]
    (4...4+@num_days16).each do |d|
      n = cnt_filled(d)  #, others)
      case n
      when 1, 0
        if @wrkdays[3][d] == ' '
          @wrkdays[3][d] = 'x'
        else
        end
      when 3, 4
        if @wrkdays[3][d] == 'x'
          @wrkdays[3][d] = ' '
        else
        end
      when 2
        ;   # ok
      else
        ;   #  ??
      end
    end  # (4..).each
    # Hyoka
    # compareCase
    # get Better
  end # shift_AI
  

  #................................
  def adjust(idx_to_change)
  #..............................
    puts "\n\n-------------------"
      puts "#  adjust( #{idx_to_change} )"
    save_Case
    puts "Case Person #{idx_to_change}"
    
#    hor_show(idx_to_change)
    #
    cnt_add=cnt_del=changed=cnt_ok = cnt_ok0 =cnt_offDays =  0
    @theMonthRange.each {|day|
      num = cnt_filled(day)
      case num
      when 2
        cnt_ok0 += 1        
      when 1, 0
        if isOffDay( @wrkdays[idx_to_change][day] )
          @wrkdays[idx_to_change][day] = 'X'
          cnt_add += 1
          changed += 1
        end
      when 3, 4
        if isOnDay( @wrkdays[idx_to_change][day] ) 
          @wrkdays[idx_to_change][day] = '*'
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
      if isOffDay(@wrkdays[idx_to_change][day] )
        cnt_offDays += 1
      end
    }

    #term_month = (3 .. @num_days16 + 4 - 1)
    
    #[- begin
#[-    examine()

    

    #[- end
    hor_show( idx_to_change )
    return  #[-
    print "===Ok==== "
    gets

    puts "# RESULTadjusted"
    puts "#   #{changed} days adjusted   On #{cnt_add}  Off #{cnt_del} for Person  #{idx_to_change}"
    puts "#       OK  Before #{cnt_ok0}  ==> After #{cnt_ok} days  "
    puts "#       Result + #{cnt_ok - cnt_ok0}"
    puts "##   OffDay is #{cnt_offDays} days"

    p "## Full Off before"
    @chk_workers[:FullOffDay][idx_to_change] = get_WithFullOffDays(
      get_SeqOffDays(
        @chk_workers[:FullOffDay ][idx_to_change]
      )
    )
    
    puts strStatus_Worker(idx_to_change)
    
    puts strStatus_Place()

    
#    ver_show
    load_Case
  end  


  #....................
  #[- ......
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
  end



end  # class
#--- End of Class ---
