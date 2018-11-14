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
#    No Need
###[- left 1     if @checked > 0
#    #      v_days=  @wrkdays[idx]
#####    # cp_2_views
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
  #   
  # @num_workers
  # ...
  # check
  #  @wrkdays
  #  @cnt_hecks
  
  #.................................................
  def initialize(members=4, fakeDate=nil )
  #.................................................
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
    daysWithOffday = get_OffDays( @wrkdays[idxWorker])   #   #  sr_offdays_array( w )
    @chk_workers[:FullOffDay][idxWorker] = get_FullOffDays( daysWithOffday )

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
#    checkCase
    ## --- start , Add dsy of seqs to under day
    # 
    #  add_OffDays(idxWorker, pos_OffDays)
    #-----------
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
    
    hor_show
#    ver_show
    cnt_add=cnt_del=changed=cnt_ok = cnt_ok0 =cnt_offDays =  0
    (4...( @num_days16 + 4) ).each {|day|
      ##      puts "# think   day #{day}   '#{@wrkdays[ idxWorker][ day ]}'"
      num = cnt_filled(day)
      if num == 2
        cnt_ok0 += 1
      end
      case num
      when 1, 0
        if @wrkdays[idx_to_change][day] == ' '
          @wrkdays[idx_to_change][day] = 'X'
          cnt_add += 1
          changed += 1
        else
        end
      when 3, 4
        if @wrkdays[idx_to_change][day] =~ /x/i
          @wrkdays[idx_to_change][day] = '*'
          cnt_del += 1
          changed += 1
        else
        end
=begin        
      when 0
      when 4
=end
      else # 2
      end
      # to  evaluate
      if cnt_filled(day) == 2
         cnt_ok += 1
      end
      case @wrkdays[idx_to_change][day]
      when ' ','*'
        cnt_offDays += 1
      end
    }

    examine()

    
    puts "# RESULTadjusted"
    puts "#   #{changed} days adjusted   On #{cnt_add}  Off #{cnt_del} for Person  #{idx_to_change}"
    puts "#       OK  Before #{cnt_ok0}  ==> After #{cnt_ok} days  "
    puts "#       Result + #{cnt_ok - cnt_ok0}"
    puts "##   OffDay is #{cnt_offDays} days"
    #term_month = (3 .. @num_days16 + 4 - 1)

    p "## Full Off before"
    (0..3).each {|w|
      p  @chk_workers[:FullOffDay][w]
#[-      get_OffDays
#      get_FullOffDays(w)
    }
    p "## Full Off AFTER"
    (0..3).each {|w|
      p  @chk_workers[:FullOffDay][w]
    }
    hor_show
    print "===Ok==== "
    gets

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


  #
  #   check & Hyouka
  #
  
  #..............................
    def examine(workers=[0,1,2,3])
    #..............................
    puts "# def examine( #{workers} )"
    #  filled '2'
    #    (4..34).each do |day|
    # for days OK?
    #
    # -------
    (0 ... 4 + @num_days16 ).each { |day|
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
    workers.each do |w|
      puts " workers = #{w}"  
      @chk_workers[:OffDay][w] = 0
      @chk_workers[:FullOffDay][w] = []
      @chk_workers[:OnDay][w] = 0
      @chk_workers[:OnDayAll][w] = 0
      (3 ... 4 + @num_days16 ).each do |day|
        @chk_workers[:OnDay][w] += 1  if isOnDay( @wrkdays[w][day] )
        @chk_workers[:OffDay][w] += 1  if isOffDay( @wrkdays[w][day] )
        @chk_workers[:OnDayAll][w] += 1  if isOnDayAll( @wrkdays[w][day] )
      end
      ##[-      @chk_workers[:FullOffDays][w] = []   @wrkdays[w])
      daysWithOffday = get_OffDays( @wrkdays[w])   #   #  sr_offdays_array( w )
      @chk_workers[:FullOffDay][w] = get_FullOffDays( daysWithOffday )
        
#      print "\n#Full Off No.#{w}  '", @chk_workers[:FullOffDay][w], "'\n\n"      
    end

=begin
    puts "# End def examine( #{workers} )"
=end
  end

end

#--- End of Class ---
