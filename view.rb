module View
#
#  For Views
  #

  #..........................
#  def color_str(filled)      
#  def set_AttrStr( num_filled )    # for line check
  def str_Attr( num_filled )    # for line check
  #...........................
##    puts "# def set_AttrStr( '#{num_filled}' )"
  # 
    # number of filled (nomal 2)
    case num_filled
    when 2      # OK
      color_str = color_str( num_filled.to_s, "NORMAL" )
    when 1
      color_str = color_str( num_filled.to_s, "RED" )
    when 3
      color_str = color_str( num_filled.to_s, "RED,BLINK" )
    when 4, 0
      color_str = color_str( num_filled.to_s, "RED" )
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
     examine()
     #      print " @chk_Place[:dayView] ='", @chk_Place[:dayView], "'\n"
     #      print " @chk_Place[:dayView][0] ='", @chk_Place[:dayView][0], "'\n"
     #      print " @chk_Place[:dayView][1] ='", @chk_Place[:dayView][1], "'\n"
     #      print " @chk_Place[:dayView][2] ='", @chk_Place[:dayView][2], "'\n"
     #      print " @chk_Place[:dayView][3] ='", @chk_Place[:dayView][3], "'\n"
     
     #              .join(filler) + '_|'
     dat = @chk_Place[:dayView][0, 4].join(filler) + '_|'
     
     ##      print " @chk_Place[:dayView][4... 4+@num_days16] ='", @chk_Place[:dayView][4... 4+@num_days16] , "' \n"
     dat = dat + @chk_Place[:dayView][4... 4+@num_days16].join(filler)
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
        cnt = cnt_filled( nth_day ) #  @num_workers)
        canv = canv + "|  [" + str_Attr(cnt) +  "]"
      end
      
      puts "" + canv
    end
  end
  
#   
end
