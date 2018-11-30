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
   
  #.........................
  def sel_MainMenu()
  #.........................
    prompt=<<-EOF
[ MAIN MENU ]
 0.  Set Initial Env
 10..  Go back to DONE Status
  11/12. Before /After set Koyan
  13.  to Prev Status
  19.  to Best Score
 2.. Change CONDTION 
   21.Shift seq  22. Pattern etc.
 3. SELECT Action 
   31.. Shift To right/left
   32.. Simple Adjust
   33.. Adjust_Round
 40.. INFO  get Best Score, show HYO
 50.. HYO :Change horizontal Mode
  51/52. Hyo only/ Hyo with Detail
 60. ENDING (decide A.B) & Print
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
        when 0
          do_test
        when 10..19
          do_GoBack(menu)
        when 2,20
        when 21
          set_nextSeq          
        when 22
        #set_Pattern
        when 3, 30..33
          do_Action(menu)
        when 40
          puts ". get Best Scend"        when 50..54
          do_HYO(menu)
        when 55
          get_BestScore
        when 60
          puts "do_Ending"
          do_Ending
          return 60
        when 7, 70
          puts ""
          return 70
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
    end # while true
  end # sel_MainMenu()

  #
  # Sub Menu / called Action

  #.............................
  def do_GoBack(menu)
  #.............................
    case menu
    when 11
      @wrkdays = load_NamedCase('_Koyano')
    when 12
      @wrkdays = load_NamedCase('Koyano_')
    when 19
      do_get_BeastScore
    end
  end

  #.............................
  def do_get_BeastScore
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
  
  #.............................
  def do_Action(menu)
  #.............................
    puts ". SELECT Action"
    if menu == 3 or menu == 30
      puts "31. ShiftTo right/left All Members"
      puts " Usage: worker, +/-N"
      puts "   +N(to Right) / -N(to Left) N days Shift"
      wrkr, ndays= get_PtnDat2('(\d),((+|-)\d+))*', 1, 3)
      
      if ndays == nil
        nday = +1
        menu = 31
      end 
      return "Q" if wrkr == "Q"
    end
    #
    case menu
     when 31
      shift_to(wrkr, ndays)
      show_Hyo
    when 33
      puts "do Adust_Round"
      adjust_Round()
      show_Hyo()
    when 32
      puts "do ShiftTo right/left All Members"
      save_Case('Before Shift')
      (0...@num_workers-1).each do |w|
        shift_to(w, 1)
        show_Hyo
        cs = load_NamedCase('Before Shift')
        @wrkdays = cs
        puts "Before Shift"
        show_Hyo(false)
      end
      puts "do Simple Adust"
    #adjust()
    end
  end # do_Action

  #.............................
  def do_HYO(menu)
  #.............................
    case menu
    when 50
      if ok_YN?("change horizontal '#{@horizontal}' Mode : Y/N" )
=begin        #
        @horizontal = !@horizontal
        puts "\nHorizontal Mode #{@horizontal} changed"
        end                
=end      
        msg="change horizontal '#{@horizontal.inspect}' Mode : Y/N "
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
end # MenuIo
