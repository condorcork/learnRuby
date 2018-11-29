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

  
  #.........................
  def sel_MainMenu()
  #.........................
    prompt=<<-EOF

[ MAIN MENU ]

 0.  Test Env
 10.  go back to Initialied #   
 11.  go back before set Koyan
 12.  go back Aftet set Koyano
 13.  go back to Prev Status
 20. change Priority (shift seq)
 21. inittialed & change Pattern
 30. SELECT Action
 31.  do ShiftTo right/left & get Best
 32.  do Simple Adust & get Best
 33.  do Adjust_Round
 40. SELECT   . get Best Score
 50. Change horizontal Mode
 51  display Hyo without Detail
 52. display Hyo with Detail
 55. display Best Score
 60. Manual Handling
 70. Quit To Top
 9.  Quit [END]
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
          puts "Menu #{menu}"
          if menu == 11
            csName='Initial'
            goBack_Start_seq()
          elsif menu == 12
            csName='_Koyano'
          else
            csName='Koyano_'
          end
          cs = load_NamedCase( csName )
          if cs != nil
            @wrkdays = cs
          end
        when 20
          set_nextSeq          
        when 21
          # change patern
        when 30
          puts ". SELECT Action"
        when 31
          puts "do ShiftTo right/left"
          save_Case('Before Shift')
          (0...@num_workers -1 ).each {|w|
            shift_to(w, 1)
            show_Hyo
            cs = load_NamedCase('Before Shift')
            @wrkday2 = cs
            puts "Before Shift"
            show_Hyo
          }
                  puts "do Simple Adust"
          #adjust()
        when 33
          puts "do Adust_Round"
          adjust_Round()
          show_Hyo()
        when 40
          puts ". get Best Scend" 
          show_Hyo()
        when 50
          if ok_YN?("change horizontal(#{@horizontal}) Mode : Y/N" )
            @horizontal = !@horizontal
            puts "\nHorizontal Mode #{@horizontal} changed"
          end
        when 51
          show_Hyo(false)
        when 52
          show_Hyo()
        when 55
          get_BestScore
        when 60
          puts "Manual Handling"
          return 60
        when 70
          return 70
        when 9
          puts "Exit"
          exit 0
        end
      when /^(\b*(H)elp\b*)$/
        puts prompt
      when /^\b*Q(uit)*\b*/i
        puts "Exit"
        exit 0
      end # case l
      puts " "
    end # while true
  end # def sel_MainMenu()
  
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
