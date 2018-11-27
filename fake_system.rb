# coding: utf-8

module FakeSystem

require 'io/console'
require 'io/console/size'
  
  
  #................
  def init_fake()
  #................
    puts "#def init_fake()"
    # @prevCase
    #
    # 1). Hisory 
    # 2). Specify
    # 
    # 3). Clear
    # 
    @savedCase = []
    @savedSeq = []            # for seq_workers 
#    @savedCase << {"ADDASDAD" => dump'}
#    @savedCase << {"noname" => dump'}
#    p @savedCase
    
  end #def init_fake()

#;- no test  
  #...........................
  def sr_dumpCase( caseKey )
  #...........................
    puts "#def sr_dumpCase( caseKey }"
    retIdx = []
    @savedCase.each_with_index { |e, i|
      if e.keys.include?(caseKey)
        retIdx << i
      end
    }
    retIdx 
  end #def sr_dumpCase( caseKey }"

  #..........................
  def load_theCase(caseName)
  #..........................
    puts "#def load_theCase(caseName)"
    cases = sr_dumpCase( caseName )
    case cases.size
    when 0
      puts "#!! --- Error  load_theCase"
      puts "#!! --- case '#{casename}' NOT SAVED)"
    when 1
      load_Case( caseName[0][ caseName ] )
#      _Marshal=nil)   # case (Marshal.dump)
#      cases[0]
    else
      
    end
  end #def load_theCase"
    
  
  #-----------------------------
  def save_Case( nameCase = 'noname' )
    #-----------------------------
    puts "#def save_Case  size #{@isInitState}"    
    prevCase = Marshal.dump( @wrkdays )
    @savedCase << { nameCase => prevCase }
    prevSeq = Marshal.dump( @seq_workers )
    @savedSeq << prevSeq  # for seq_workers 
#    p @prevCase
#    p @savedCase  
  end

  #-----------------------------
  def load_Case(dumped_Marshal=nil)   # case (Marshal.dump)
  #----------------------------
    puts "#def  load_Case( case_Marshal )"
    if dumped_Marshal == nil
      # load Previous which was recently saved
      prevCase = @savedCase[-1]
      if prevCase == nil
        puts "#!! load_Case DO Nothing!!  'dumped_Marshal==nil' )"
        nil
      else
        prkey= @savedCase[-1].keys[0]
        dump_Dat = @savedCase[-1][prkey]
        saved = Marshal.load( dump_Dat )
        #  seq
      end
=begin        
=> [{"noname"=>"Noname 1"}, {"noname"=>"Noname 2"}, {"Init"=>"Init 1"}]
irb(main):067:0> m[-1][mk]
=> "Init 1"
irb(main):068:0> 
=> "Init"
irb(main):069:0> m[-1][mk]
=> "Init 1"
=end
#[-        @savedCase.pop  # when delete 
#      end
    else
      saved = Marshal.load( dumped_Marshal )
    end
    saved
  end # def load_Case(case_Marshal)   # case (Marshal.dump)

  #
  #-----------------------------
  def allSavedCase( caseName = nil )
  #-----------------------------
    # --> def sr_dumpCase( caseKey )
    puts "#def allSavedCase"
    retIdx = []
    retAll = []
    @savedCase.each_with_index { |e, i|
      retAll << i
      if caseName != nil
        if e.keys.include?(caseName)
          retIdx << i
        end
      end
    }
    puts "#!!! ALL @savedCase.keys "
    retAll.each {|keyname| puts " :'#{keyname}'"  }
    puts "#!!! Searched key '#{caseName}'"
    retIdx.each {|keyname| puts " :'#{keyname}'"  }
    if caseName != nil
      retIdx
    else
      retAll
    end
  end  #def allSavedCase
  


  #;- no test  
  #----------------------------
  def copy_Data( src, target)
  #----------------------------
    puts "# def copy_Data( src, target)"
    target = Marshal.load( Marshal.dump( src ) )
  end # def copy_Data( src, target)

=begin  
  #..............
  def getchar()
  #..............
    while (key = STDIN.getch) != "\C-c"
      puts "#{i += 1}: #{key.inspect}  Key Pressed 。"
    end
  end # def getchar()
=end
  
end # module FakeSystem
