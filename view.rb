module View
#
#  For Views
  #
  #..........................
  def color_str(str, color='')
  #...........................
#    puts "# def color_str(#{str}, #{color})"
    case color
    when 'RED'
      colorstr='31'
    when 'GREEN'
      colorstr='32'      
    when 'YELLOW'
      colorstr='33'
    when 'NORMAL'
      colorstr='0'
    else
      colorstr='34'
    end
    "\033[" + colorstr + 'm' + str + "\033[0m"
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
end
