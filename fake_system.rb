# coding: utf-8

module FakeSystem

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
    @prevCase = Marshal.dump( @wrkdays )
    @savedCase << { nameCase => @prevCase}
  end
  
  #-----------------------------
  def load_Case(dumped_Marshal=nil)   # case (Marshal.dump)
  #----------------------------
    puts "#def  load_Case( case_Marshal )"
    if dumped_Marshal == nil
      if @prevCase == nil
        puts "#!! load_Case DO Nothing!!  'dumped_Marshal==nil' )"
        nil
      else
        Marshal.load( @prevCase )
#[-        @savedCase.pop  # when delete 
      end
    else
      Marshal.load( dumped_Marshal )
    end
  end # def load_Case(case_Marshal)   # case (Marshal.dump)

#;- no test  
  #----------------------------
  def copy_Data( src, target)
  #----------------------------
    puts "# def copy_Data( src, target)"
    target = Marshal.load( Marshal.dump( src ) )
  end # def copy_Data( src, target)
  
end
