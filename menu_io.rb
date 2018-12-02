# coding: utf-8
module MenuIo

require 'io/console'
require 'io/console/size'

  
  #.............................
  def ok_YN?(prompt="continue \n  Yes: Y, y, Cr\n  No: N, n\n  Q[q] stop [Y|N|\\n|Q] ? :")
  #.............................
    print prompt
    while (key = STDIN.getch) != "\C-c"
      case key  # .inspect
      when /[yY]/
        return true
      when /[N]/i
        puts "[N]o "
#        Exit 1
        return false
      when /Q/i
        puts "EXIT 0"
        exit 0
      when "\r"
        return true
      end
      puts "'#{key}' '#{key.inspect}'"
    end
    puts "\C-c"
    exit 1;
  end


=begin  
  #.............................
  def get_PtnDat2( ptn, *matchN )
  #.............................
    puts "Enter #{ptn}"
    puts "#{ptn}"
    cs=1
    case matchN.size
    when 2
      case matchN[1]
      when 2
        cs=2
      when 3
        cs=3
      when 4
        cs=4
      end
    end
    
    while true
      l=gets
      if l =~ /#{ptn}/
        x=$1
        case cs
        when 1
          y=nil
        when 2
          y=$2
        when 3
          y=$3
        when 4
          y=$4
        end
        #x= $"#{matchN[0]}"
        return x,y
      elsif l =~ /^Q/i
        return 'Q'
      end
    end
  end # get_PtnDat2
=end
  
  #.........................
  def sel_MainMenu()
  #.........................
    prompt=<<-EOF
[ MAIN MENU ]
0.  Set Initial Env
1[0]..[sMenu] 
2[0]..[sMenu] Change CONDTION 
 21.Shift seq  22. Pattern etc.
30..[sMenu]  Go back to DONE Status
 31/32. B/A Koyan  33. Prev 39. Best
4[0]..[sMenu] SELECT Action 
 41.Shift 42.Adjust 43. Adjust_Round
5[0]..[sMenu] INFO
 51.Best Score, show HYO
60..[sMenu] HYO :Change horizontal Mode
  61/62. Hyo only/ Hyo with Detail
70. ENDING (decide A.B) & Print
70.
8[0]. Manual Handling
 H(elp)/M(enu): show This Menu"
 9[0], Q[uit].   Exit 
EOF
    print prompt
    print ' : '
    
    casename = []
    
    while true
      print ": "
      l=gets.chop
      case l
      when /^(\b*(\d+)\b*)$/
        menu = l.to_i
        case menu
        #--  Condition 0,1[0], 2[0], 3[0]
        when 0   # Initial set & Check
          puts '# Initial Env'
        #          do_test
 #         do_initEnv
        when 1, 10, 11..19    # 
          # 11. xxxShift seq  12. Pattern etc.
#          do_ChngActCond(menu) # 20
        when 2, 20, 11..29    # Change CONDTION #
          # 21. Shift seq  22. Pattern etc.
          do_ChngActCond(menu) # 20
        when 3, 30, 31..39    # 30..GoBack #
          # 32/33. B/A Koyan  34. Prev  39. Best
          do_GoBack(menu)
        #-- Action    
        when 4, 40, 41..49 # SELECT Action 
          # 41. Shift  42. Adjust  43. Adjust_Round
          do_Action(menu)
#        when 40
#          puts ". get Best Scend"
#          do_HYO(menu)
        when 50..59
          do_HYO(menu)
          #get_BestScore
        when 60
          puts "do_Ending"
          do_Ending
    #      return 60
        when 7, 70
          puts "menu: 70"
   #       return 70
        when 8, 80
          puts "Manual Handling"
          sel_ToggleExchange()
        when 9, 90
          puts "Exit"
          exit 0
        end
      when /^(\b*(H)(elp)*\b*)$/i
        puts "when /^(\b*(H)elp\b*)$/i"
        puts prompt
      when /^\b*Q(uit)*\b*/i
        puts "when /^\b*Q(uit)*\b*/i"
        puts "Exit"
        exit 0
      end # case l
      puts "loop ENter Error #{l}"
    end # while true
  end # sel_MainMenu()

  #.............
  def do_ChngActCond(menu) # 20  
  #.............
    puts '#20# do_ChngActCond'
    if menu == 20 or menu == 2
      puts '21 seq  22 pattern Q[uit] '
      while true
        l=gets.chop
        if l =~ /Q/i
          # no action
          return
        else
          case l.to_i
          when 21, 22
            menu = l.to_i
          break
          end
        end
      end # while true
    end # if 
    #
    case menu
    when 21
      set_nextSeq
    when 22
      puts '# change PATERN'
    end # case menu
  end #do_ChangeCond

  #.............................
  def do_GoBack(menu)   # 30 GoBack
  #.............................
          # 32/33. B/A Koyan  34. Prev  39. Best
    if menu == 3 or menu == 30
      puts '32/33. B/A Koyan  34. Prev  39. Best  Q[uit] '
      while true
        l=gets.chop
        if l =~ /Q/i
          # no action
          return
        else
          case l.to_i
          when 32, 32, 34, 39
            menu = l.to_i
            break
          end
        end
      end # while true
    end
    
    case menu
    when 32
      ret = load_NamedCase('_Koyano')
      if !ret
        show_Hyo(false)
      else
        @wrkdays = ret
      end
    when 33
      ret = load_NamedCase('Koyano_')
      if !ret
        show_Hyo(false)
      else
        @wrkdays = ret
      end
    when 34    # PrevCase
      load_PrevCase()
      show_Hyo(false)
    when 39

    end
  end

  #.............................
  def do_get_BestScore
  #.............................
    case @bestScore[0][:num]
    when 0
      puts '#!! best score Not YET Gotten'
      return
    when 1
      load_BestScore
    when 2
    end
  end # def do_get_BeastScore
  
  #.............................
  def do_Ending(isContinue=true)
  #.............................
    show_Hyo
    if !ok_YN?('test marshal.file ')
      return
    end
=begin    ### To File 
file = File.open("/tmp/marshaldata", "w+")
Marshal.dump({:a => 1, :b => 3, :c => 5}, file)

# fileポインタが最後の位置にあるので最初から読み込めるように以下を実行
file.rewind
# => 0
Marshal.load(file)
# => {:a=>1, :b=>2, :c=>3}
=end
#puts 'test File Marshal'    
#    show_Hyo
    file = File.open("./data/marshal_WrkDays", "w+")
    Marshal.dump(@wrkdays, file)
    show_Hyo
    sel_ToggleExchange()    
    show_Hyo
    puts 'Get From File '
    file.rewind
    @wrkdays = Marshal.load(file)
    show_Hyo
  end

  def save_fileMarshal
    file = File.open("./data/marshal_WrkDays", "w+")
    Marshal.dump(@wrkdays, file)
  end

  
  #.............................
  def do_Action(menu, *wrker_dir_ndays)    # 4. 40.
  #.............................
    puts ". SELECT Action"
    if menu == 4 or menu == 40
      puts "\n31. ShiftTo right/left All Members"
      puts " Usage: worker, +/-N[, day1,day2]"
      puts "   +N(to Right) / -N(to Left) N days Shift"
#      puts "   option [ ,day1, day2]  .... 38"
#      puts "    Shift(Slide) from day1 to day2  -N/N days Shift"
      puts "42. Adjust a Member"
      puts "43. Adjust RoundS"
      print ' 41 42 43 :'
      ret = get_MenuDat(/^\s*(\d|Q)\s*(,\s*(\-*\d+),\s*(\d+),*\s*(\d+)*)*\s*$/i, {:cmd_ => 1, :dire =>3, :day1 =>4, :day2=>5})
      if ret[:cmd_] =~/Q/
        return
      end
      wrkr = ret[:cmd_].to_i
      dir   = ret[:dir].to_i
      nday  = ret[:day1].to_i
      #
      # nday2  = ret[:day2].to_i
      menu=41
    elsif menu == 41
      wrkr = wrker_ndays[0]
      dir   = wrker_ndays[1]
      ndays   = wrker_ndays[2]
#      ndays2   = wrker_ndays[3]
    end
    #
    case menu
     when 41
      puts "# ShiftTo right/left  for #{wrkr}"
      shift_to(wrkr, dir )
      show_Hyo
     when 42
      puts "# ShiftTo All Members & get Best"
      save_Case('Before Shift')
      score=[]
      idxbest = 0
      # Koyano Can Not Shift 
      (0...@num_workers - 1).each do |w|
        cs= load_Case
        @wrkday2 = cs

        shift_to(w, 1)
        show_Hyo
        
        score[w] = get_Score
        if w = 0
          idxbest = w
        else
          if score[w] > score[idxbest]
            idxbest = w
          end
        end
      end
      #           0 1 2   w(orker)
      #           2 1 0   before
      #  idxbest
      #  when 2 (3-1) - 2 = 0  current
      #       1    2  - 1 = 1  before
      #       0    2  - 0 = 2  before
      ipos = ( @num_workers - 1 ) - idxbest 
      CasePop(ipos)
      cs = load_Case(nil, true)    # load & pop(del)
      if cs != nil
        @wrkday2 = cs
      end
      show_Hyo
    when 43
      puts "do Adust_Round"
      adjust_Round()
      show_Hyo()
      #adjust()
    end
  end # do_Action

  #.............................
  def do_HYO(menu)     # 50..
  #.............................
    puts "#50# .. HYO .."
    if menu == 5 or menu == 50
      puts "\n 51. HYO only"
      puts " 52. HYO with DatailU"
      puts " 59. Change Horizontal/ Vertival Mode"
      print ' 51 52 59 Q :'
      while true
        ret = gets.chop
        if ret =~/^\s*(\d\d|Q)\s*/i
          if ret =~/Q/
            return
          end
          print  "<> '#{ret}'  => '"
          menu=ret.to_i
          puts "'   '#{menu}'"
          break
        end
        puts "loop #{ret}"
      end
    end
    #  def do_Change
    puts "sel Do ==> #{menu}"
    case menu
    when 59
      if ok_YN?("change horizontal '#{@horizontal}' Mode : Y/N" )
        msg="\nchange horizontal '#{@horizontal.inspect}' Mode : Y/N "
        if ok_YN?( msg ) == true
          @horizontal = !@horizontal
          puts "\nHorizontal Mode #{@horizontal} changed"
        end
      end                
    when 51
      show_Hyo(false)
    when 52
      show_Hyo()
    end
  end # do_HYO
  #
  
  #.........................
  def sel_ToggleExchange(msg=nil)
  #.........................
    puts msg if msg != nil
    prompt=<<-EOF

[ Manual HANDLING ]
 'worker, day':     Toggle On/Off 
 'w1,day1 w2,day2': Exchange 
                     day1 day2
  'M' :    Upper Menu
  'Q' :    Quit from This Menu  
EOF
    print prompt
    print ': '
    ret=[]
     while true
      l=gets
      l.chop!
      case l
      when /((\d), *(\d+))([ \t]+(\d),[ \t]*(\d+))*/
        ret[0]=$2.to_i
        ret[1]=$3.to_i
        if $4 != nil
          ret[2]=$5.to_i

          ret[3]=$6.to_i
        end
        return ret
      when /^[ \t]*Q/i
        puts "Exit"
        exit 0        
#        break
      when /^[ \t]*M/i
        return 'M'
      end
    end
  end # def sel_ToggleExchange(msg=nil)

  #............................
  def get_MenuDat(ptrn, param)
  #...........................
    puts ptrn
    while true
      menu=gets.chop!
      ret = {}
      if menu =~ /#{ptrn}/ 
        param.each {|k, v|
          ret[k] = $~[v]
          p ret
          return ret
        }
      end          
    end
  end # get_MenuDat

end # MenuIo
