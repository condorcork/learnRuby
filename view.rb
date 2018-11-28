module View
#
#  For Views
  #

  #..............
  def init_View()
  #..............
    puts "# def init_View()"
    @horizontal = true
  end #def init_View()


  #..........................
  def str_Attr( num_filled )    # for line check
  #...........................
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
    color.split(',').each {|c|
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
      when 'REVERSE'
        c_str='7'
      else
        c_str='34'
      end
      attr += c_str + ';'
    }
    if attr[-1] == ';'
      attr.chop!
    end

    ret  = "\033[" + attr + 'm' + str + "\033[0m"
    ret
  end

  #.............................
  def hor_show( dispResult = true )    #[- Param show Result or Not
  #.............................
  #  puts "# def hor_show( #{chk_Worker} )"
    #  Prepare Check Line
    examine()
#
    # for Header & Guide
    #
    hdrDay   = "  |"
    hdrMonth = "Dy|"

    footer='0 1 2 3 |'
    ff = '4 + 6 7 8 9<1>1 2 3 4 + 6 7 8 9<2>1 2 3 4 + 6 7 8 9<3>1 2 3 4'.slice(0,  @num_days16*2)
    footer += ff
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
    ##
    guide= (' 1'..' 9').to_a.join + ' + '
    guide[0]=''
    guide= ". . . . |" + guide*3 +'.'
    puts ' ' * hdrDay.length + guide
    # ??      puts  "Here  #{(  4 + @num_days16 - 16  - @num_days16.to_s.length )}"
    strPrevMonth = '+-' *  4 + '|' #
    strPrevMonth += '+-' * ( @num_days16 - 15 )

    date_nextMonth = nextMonth()
    #      nextMonth.month
    puts hdrMonth + strPrevMonth + "<<---  " + date_nextMonth.month.to_s + " ----"
    puts hdrDay + hdr
    #
    # Each Worker On/Off days
    #
    filler = '_'
    (0...@num_workers).each do |idx|
      # 4 days of prevMonth to Ref
      kinmuM = @wrkdays[idx][0..3].join(filler)
      # this month
#[-      dat = @wrkdays[idx][4... 4+@num_days16].join(filler)
      dat_=@wrkdays[idx][4... 4+@num_days16].dup
      dat = dat_.join(filler)
      
      if dat =~ /[X\*]/
        dat.gsub!(/[X\*]/) {|s|
          color_str(s,'REVERSE,GREEN')
        }
        dat.gsub!('*',' ')
        dat.gsub!('X','x')
      end
      kinmuM = kinmuM + '_|' + dat + filler
      hdr = "#{idx}.|"
      puts hdr + kinmuM
    end
    #  check  Row,  Last Line

     dat = @chk_Place[:dayView][0, 4].join(filler) + '_|'

     dat = dat + @chk_Place[:dayView][4... 4+@num_days16].join(filler)

     puts "<>|#{dat}"    # when PC
     puts 'IX|' + footer

     if dispResult
       show_Result
     end
  end  

  #...................
  def show_Result()
  #...................
    (0...@num_workers).each {|w|
      puts strStatus_Worker(w)
     }
    #[- to do, More simple 
    puts strStatus_Place()
    point = get_Score
    puts "Point = #{point}"
    point
  end #  def show_Result()
  
  #.............................
  def ver_show(  dispResult = true )
  #.............................
  #  puts "# def ver_show( "
    (0..34).each do |day|
      if day == 4
        puts '  ==|=================='
      end
      printf " %2d ", day
      canv =[]
      (0...@num_workers).each { |wrkr|
        #
        dat= Marshal.load (Marshal.dump( @wrkdays[wrkr][day] ))
        #   dat= @wrkdays[wrkr][day]
        if dat =~ /[X\*]/
          dat.sub!(/[X\*]/) {|s|
            color_str(s,'REVERSE,GREEN')
          }
          @wrkdays[wrkr][day].sub!('*',' ')   
          @wrkdays[wrkr][day].sub!('X','x')   
        end
        #
        canv << @wrkdays[wrkr][day]
      }
      canv= '|__' + canv.join("___")  + '___'
#      if checkview == true
        cnt = cnt_filled( day ) 
        canv = canv + "|  [" + str_Attr(cnt) +  "]"
#      end
      
      puts "" + canv
    end

    if dispResult
      show_Result
    end
  end

  #....................
  def show_Hyo( isResult=true ) 
  #....................
  #  puts "#def show_Hyo( isResult=true )"
    if @horizontal
      hor_show(isResult)
    else
      ver_show(isResult)
    end
  end #def show_Hyo( isResult=true ) 
#   
end # module View
