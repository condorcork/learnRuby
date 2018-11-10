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
=begin # mved to Helper
#  27 lines skipped
=end

#  -- set last 4 days of prev month 
#  def prepare(idx, prevdays=' '*4, nvotAvail={})
# 


class Yotei

#=== 'include './View'' ===#
#=== including < view.rb > ===
# 'module View'
#
#  For Views
  #

  #..........................
#  def color_str(filled)      
  def set_AttrStr( filled )    # for line check
  #...........................
##    puts "# def set_AttrStr( '#{filled}' )"
  # 
    # filled number (nomal 2)
    case filled
    when 2
      color_str = color_str( filled.to_s, "NORMAL" )
    when 1
      color_str = color_str( filled.to_s, "RED" )
    when 3
      color_str = color_str( filled.to_s, "RED,BLINK" )
    when 4, 0
      color_str = color_str( filled.to_s, "RED" )
    end
  end
  
  #..........................
  def color_str(str, color='')
  #...........................
#    puts "# def color_str(#{str}, #{color})"
    attr=""
#    puts "# color #{color}"
    color.split(',').each {|c|
#      puts "## each attr '#{c}'"
      case c
      when 'RED'
        c_str ='31'
      when 'GREEN'
        c_str ='32'      
      when 'YELLOW'
        c_str ='33'
      when 'MAGENTA'
        c_str = '35'
      when 'NORMAL'
        c_str='0'
      when 'BLINK'
        c_str='5'
      else
        c_str='34'
      end
      attr += c_str + ';'
    }
    attr.chop!     # delet last cahr ;
  #      print "## attr ='", attr, "'\n"
    ret  = "\033[" + attr + 'm' + str + "\033[0m"
   #     print "## attr End ='", ret, "'\n"
   #  ret
  end

  #.............................
  def hor_show(chk_members=[0,1,2,3], checkview=true)
  #.............................
    puts "# def hor_show( #{chk_members}, #{checkview} )"
    # for Header & Guide
    if checkview
#      itemName2= "        |"
      hdrDay   = "        |"
      hdrMonth = "  Date  |"
      hdr=". "*4 + "|16. . . 20. . . . , . . "    # until 28th
      (28..@num_days16).each {|d|
        if d == 30
          if d != @num_days16
            hdr=hdr + d.to_s
          else
            hdr=hdr + '+ '
          end
        else
          hdr=hdr + '. '
        end
      }
      #   puts "16--31  '#{hdr}'"
      hdr=hdr+ "1 . . . + . . . . 10. . . . 15"
      guide= (' 1'..' 9').to_a.join + ' + '
      guide[0]=''
      guide= ". . . . |" + guide*3 +'.'
      #  when Smafo
#      puts guide
#      puts hdr
      #  when PC
      puts ' ' * hdrDay.length + guide
# ??      puts  "Here  #{(  4 + @num_days16 - 16  - @num_days16.to_s.length )}"
      strPrevMonth = '+-' *  4 + '|' #
      strPrevMonth += '+-' * ( @num_days16 - 15 )
                               #     puts "'#{strPrevMonth}'  #{strPrevMonth.length}   strPrevmaon Len" 
#      strPrevMonth = strPrevMonth
#      strMonth = " " + @month_16.to_s + " "
#      centerPos = ( strPrevMonth.length - strMonth.length ) / 2
#      t = strMonth.slice(0, centerPos - 1) + strMonth
#      t = ( strPrevMonth.length - t.length )

      nextMonth = Date.new(@year_16, @month_16, 28) + 28
#      nextMonth.month
      puts hdrMonth + strPrevMonth + "<<---  " + nextMonth.month.to_s + " ----"
      puts hdrDay + hdr
      #
    end
    #
    filler = '_'
    chk_members.each do |idx|
      # 4 days of prevMonth to Ref
      kinmuM = @wrkdays[idx][0..3].join(filler)
      # this month
      dat = @wrkdays[idx][4... 4+@num_days16].join(filler)
      kinmuM = kinmuM + '_|' + dat + filler
      #      puts kinmuM                       # Smafo
      puts "  No. #{idx} |" + kinmuM      # PC
    end
    if checkview
      dat = ' '
      (0..34).each {|nday|
        @check_info[:daycheck][nday] = cnt_filled(nday, chk_members)
        @check_info[:dayview][nday] = checked_str( @check_info[:daycheck][nday] )
      }
      dat = @check_info[:dayview][0..3].join(filler) + '_|'
      dat = dat + @check_info[:dayview][4... 4+@num_days16].join(filler)
#      puts dat                      # when Smafo
      puts " check  |#{dat}"    # when PC
    end
  end  
  
  #.............................
  def ver_show(chk_members=[0,1,2,3],   checkview=true)
  #.............................
    puts "# def ver_show( #{chk_members}, #{checkview} )"
    chk_members.each do |worker|
      if ! (0...@num_workers).include?( worker )
        puts "Unkown worker index #{worker} : expected (0 .. #{@num_workers} )"
        exit 1
      end
    end
    (0..34).each do |nth_day|
      if nth_day == 4
        puts '  ==|=================='
      end
      printf " %2d ", nth_day
      canv =[]
      chk_members.each { |worker|
        canv << @wrkdays[worker][nth_day]
      }
      canv= '|__' + canv.join("___")
      + '___'
      if checkview == true
        cnt = cnt_filled( nth_day, chk_members ) # - @num_workers)
        canv = canv + "|  [" + checked_str(cnt) +  "]"
      end
      
      puts "" + canv
    end
  end
  
#   
#== END #===
'end'  ===#
#[ end  # of module
#=== << view.rb >> included
#=== 'include './ControlHelper'' ===#
#=== including < control_helper.rb > ===
# 'module ControlHelper'

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
  
#== END #===
'end'  ===#
#[ end  # of module

#=== << control_helper.rb >> included
  
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
  def initialize(members=1, fakeDate=nil )
  #.................................................
        # @month_16
    # @num_days16..[28/29/30/31]

    @debug_= 2
#
#    @debug_ = 3  # 0,1, 2

    if fakeDate != nil
      d=fakeDate.split('-')
      d.map!(&:to_i)
      p d
      date=Date.new(d[0], d[1], d[2])
    else
      # Honban
      date=Date.today
    end
    #
    #.... Set to Supose
    #    t =Time.now
    #    date=Date.new(t.year, t.month, t.day) # 2018, 12, 1)

    #[- Honban --]
    # date=Date.today
#....
    puts "tmp Today : #{date.year} #{date.month} #{date.day}\n\t#{date}"
    #
    if date.day < 7
      @month_16= date.month
      @year_16 = date.year
    else
      @month_16=date.next_month.month
      @year_16 = date.next_month.year
    end
    #
    @num_days16= daysOfMonth(@year_16, @month_16)
    @wday_16 = Date.new(@year_16, @month_16, 16).wday
    
#    @num_idx_days = @num_days16 + 15

#    puts "@num_idx_days = @num_days16 + 15"
#    puts "#{@num_idx_days} = #{@num_days16} + 15"
#  exit
#    if @debug_ > 0
      puts " #{@year_16}-#{@month_16} has #{@num_days16} days."
      puts "           #{@month_16}-16  #{%w(Su Mo Tu We Th Fr Sa)[@wday_16]}(#{@wday_16}) "
#    end
    #     @startday=Time.now # .month
    @template=('xxx  '*8).split('')
    @num_workers = members
    
#    if @debug_ > 0
      puts " This has #{@num_workers} members" 
#    end
    
      @wrkdays=Array.new( @num_workers + 1, Array.new(35, ' ') )
    #[-  no use  
    @viewsdays=Array.new( @num_workers + 1, Array.new(35, ' ') )
    @cnt_checks=Array.new( @num_workers - 1, Array.new(2, 0) )
    # check info & views
    @check_info=Hash.new()
    @check_info[:ake]=[0...@num_workers]
    @check_info[:kokyu]=[0...@num_workers]
    @check_info[:kinmu]=[0...@num_workers]
    @check_info[:day]=[0...@num_workers]
    @check_info[:daycheck]=[0...31+4]
    @check_info[:dayview]=[0...31+4]
#
#    @dayStatus={}
#    @dayStatus[:dayOn]=['X', 'x']      # On Job
#    @dayStatus[:dayOff]=[' ', 'y']     # Off Job 
    #    @dayStatus[:dayDame]=['D', 'Y']    # Not Availfor JOB
    #
    _OnDay = 'X'
    _OffDay = ' '
    _ReservedDay = 'D'

    @daySpecifiers={}
    @daySpecifiers[:OnDay]    = 'x'
    @daySpecifiers[:OffDay]   = ' '
    @daySpecifiers[:ReservedDay] = 'D'
    @daySpecifiers[:FreeDay]   = ' '
#    @daySpecifiers[:ERR] = 'D'
    @daySpecifiers[:FreeDay]   = ' '

    p @daySpecifiers
=begin 
#  7 lines skipped
=end    

    @daySpecifiers[:Defined] =  @daySpecifiers.keys.map{ |k|
      @daySpecifiers[k]
    }
    #
    @daySpecifiers[:Defined]
    print "# daySpecifiers[:Defined] "; p @daySpecifiers[:Defined]

    print " Org    "; p @daySpecifiers[:Defined]
    @daySpecifiers[:Defined].flatten!
    print " Fatten ";
    @daySpecifiers[:Defined]
    print " UNiq   ";
    @daySpecifiers[:Defined].uniq!
    p @daySpecifiers[:Defined]

    
    p @daySpecifiers[:CanAdds]
    print "# @daySpecifiers[CanAdds] "; p @daySpecifiers[:CanAdds]
    @daySpecifiers[:CanAdds] = @daySpecifiers[:Defined ]  -[  @daySpecifiers[:OnDay] ] # - @daySpecifiers[:ReservedDay]

p "CanAdds ", @daySpecifiers[:CanAdds]                                                                                             
        
p "START include ? "
    p @daySpecifiers[:Defined].include?('x')
    p @daySpecifiers[:Defined].include?(' ')
    p @daySpecifiers[:Defined].include?('D')
    p @daySpecifiers[:Defined].include?('Y')
    p " Check :Keys"
    p @daySpecifiers.keys.include?(:FreeDay)
    p @daySpecifiers.keys.include?(:OnDay)
    days=[' ', 'x' ]
    print " days[1]= '#{days}'"

    days[1] = @daySpecifiers[:OnDay]
    print " days[1]= '#{days[1]}'"
    #
    p @daySpecifiers[:Defined].include?(days[1])

#    p " Check :Keys"
#    p @daySpecifiers.keys.include?(:FreeDay)
#    p @daySpecifiers.keys.include?(:OnDay)
    
    p "END include ? "
    _symOnJob=[ 'X', 'x' ]
    _symOnOther = [ 'D' ]
    _symOnJobAll = _symOnJob + _symOnOther 
    #
    _symOffJob = [ ' ' ]
#    _symOffJob =  _symOffJob.dup
#    _symOffJobAll += 'D'
    _symAll = _symOnJobAll + _symOffJob
    print "# _symAll "; p _symAll
    
    _symCanAdd = _symAll - _symOnJobAll
    print "# _symCanAdd "; p _symCanAdd

=begin
#  5 lines skipped
=end
    xx=' '
#    if _symAll.include?(xx)
      print "Corrrect Specifier ? '#{xx}'    :";p _symAll.include?(xx)
      print "OnJob    :"; p _symOnJob.include?(xx)
      print "OnJobAll :"; p _symOnJobAll.include?(xx)
      print "Off Job  :"; p _symOffJob.include?(xx)
      print "Can Add  :"; p _symCanAdd.include?(xx)

    
    @serCase=[]

      #    end
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
#  5 lines skipped
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
  
  #.............................
  def checked_str(num_filled)
  #.............................
    str_dat= num_filled.to_s
    case num_filled
    when 0
      column = color_str(str_dat, 'NORMAL')
    when 1
      column = color_str(str_dat, 'RED')
    when 3
      column =color_str(str_dat, 'RED')
    when  2   
      column =color_str(str_dat, 'GREEN')
    else
      column =color_str(str_dat, 'RED')
    end
    column
  end
  
  #..............................
  def examine(ex_workers=[0,1,2,3], isview=true)
  #..............................
    puts "# def examine( #{ex_workers}, #{isview} )"
    #  filled '2'
#    (4..34).each do |day|
    (4...4 + @num_days16 ).each do |day|
=begin        
#  26 lines skipped
=end
      @check_info[:daycheck][day] = cnt_filled( day )
      @check_info[:dayview][day] = set_AttrStr( @check_info[:daycheck][day] )
    end
    if isview
#      ver_show(ex_workers)
      hor_show(ex_workers)
    end
    puts "# End def examine( #{ex_workers}, #{isview} )"
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


  def checkCase()
   
#=begin
    filled_days=Array.new(5, 0)
    (4... 4+ @num_days16).each {|d|
      ninzuDay=@check_info[:daycheck][d]
      filled_days[ninzuDay]+=1
    }
    
    puts "Hyoka After Koyno (Filled) "
#=begin
#         '  0   ==>     '
    puts "  Members   days "
    cnt_errDays=0
    filled_days.each_with_index {|val,idx|
      if idx != 2
        #    puts "  " + color_str( idx.to_s, 'RED' ) + "    ==>    " + colo _str(val.to_s, 'RED')
        puts " " + idx.to_s + "      = " + val.to_s
        cnt_errDays+=val
      else
        puts " " + idx.to_s + " (OK) = " + val.to_s
      end
    }

    puts "# Error (Over or Under )  = #{cnt_errDays} "
  end

  #................................
  def presetKoyano(idxWorker, howTo=0) 
    #..............................
    #  howTo : how to Add OnDay
    #         0 : OnDay set to lastday of seq 3 days
    # not only weekly,
    # but for General use
    # suposed already set Dame Days
    
    puts "#  presetKoyano( #{idxWorker} )"

    #... Search consequent ' '
    pos_OffDays =
      sr_offdays_array(idxWorker)
    
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

    examine([0,1,2,3], true)
    checkCase
   
    ## --- start , Add dsy of seqs to under day
    # 
    #  add_OffDays(idxWorker, pos_OffDays)
    #-----------
  end
  
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
      puts "#--- strDays.slice(distance, 100)    "
      puts "#----'" + "....+....0"*4
      puts "#--- '#{strDays}'   len=#{strDays.length}"
      strDays = filler + strDays
      puts "#--- strDays = filler + strDays"
      puts "#--- '#{strDays}'   len=#{strDays.length}"
      strDays = strDays.slice(0, @num_days16)
      puts "#=== strDays = strDays.slice(0, @num_days16)"
      puts "#----'" + "....+....0"*4
      puts "#--- '#{strDays}'   len=#{strDays.length}"
    else
      strDays = strDays.slice(distance, 33)  + filler
    end
    strDays = @wrkdays[idxWorker].join('').slice(0,4) + strDays
    @wrkdays[idxWorker] = strDays.split('')
  end

  #................................
  def adjust(idx_to_change)
    #................................
    puts "\n\n-------------------"
    puts "#  adjust( #{idx_to_change} )"
    save_Case
    puts "Case Person #{idx_to_change}"
    hor_show
    cnt_add=cnt_del=changed=cnt_ok = cnt_ok0 =cnt_offDays =  0
    (4...( @num_days16 + 4) ).each {|day|
      ##      puts "# think   day #{day}   '#{@wrkdays[ idxWorker][ day ]}'"
      num = cnt_filled(day, [0,1,2,3])
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
#  2 lines skipped
=end
      else # 2
      end
      # to  evaluate
      if cnt_filled(day, [0,1,2,3]) == 2
         cnt_ok += 1
      end
      case @wrkdays[idx_to_change][day]
      when ' ','*'
        cnt_offDays += 1
      end
    }
    puts "# RESULTadjusted"
    puts "#   #{changed} days adjusted   On #{cnt_add}  Off #{cnt_del} for Person  #{idx_to_change}"
    puts "#       OK  Before #{cnt_ok0}  ==> After #{cnt_ok} days  "
    puts "#       Result #{cnt_ok - cnt_ok0}"
    puts "##   OffDay is #{cnt_offDays} days"
    hor_show
    load_Case
  end

  #..........................
  def think(idxWorker)
  #..........................
    
    puts "#    def think( #{idxWorker} )"
    (4 .. ( @num_days16 + 4) ).each {|day|
##      puts "# think   day #{day}   '#{@wrkdays[ idxWorker][ day ]}'"
=begin
#  3 lines skipped
=end      
      if cnt_filled(day) < 2 &&  isDayOff(idxWorker, day)
        puts " # ...> Tar Tar "
      end
    }
  end

  #-----------------------------
  def save_Case(isInitState=false)
    puts "# save_Case  size #{@isInitState}"    
    #-----------------------------
    if isInitState
      @initCase=Marshal.dump( @wrkdays )
    else
      @prevCase = Marshal.dump( @wrkdays )
    end
#    @serCase << @preCase
  end
 
  #-----------------------------
#  def load_Case(saveNow=false)
  def load_Case(isInitState=false)
    #----------------------------
    puts "#  load_Case(#{isInitState})"
    if isInitState
      if @initCase
        @wrkdays = Marshal.load(@initCase)
      end
    else             
      if @prevCase
        @wrkdays = Marshal.load(@prevCase)
      end
    end
    return
    print  "# load_Case "
    if ! @serCase.empty?
      puts " size #{@serCase.size}"
#=begin      
#      if saveNow
#        nowCase=Marshal.dump( @wrkdays )
#      end
      @wrkdays = Marshal.load(@serCase.pop)
      #
#      if saveNow
#        @serCase << nowCase
#      end
#=end
    end
    puts ''
  end
end
#--- End of Class ---
__END__
# followng lines omitted
#  15 lines skipped by __END__
#__END__
