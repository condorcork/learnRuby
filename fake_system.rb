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
    # 3). Clear
    # 
    @savedCase = []
    @savedSeqWrkr = [] # for seq_workers 
    #    @savedCase << {"noname" => dump'}
  end #def init_fake()

  #...........................
  def sr_dumpCase( caseName )
  #...........................
  #  index for load @seq_workers 
   puts "#def sr_dumpCase( caseName }"
    retIdx = []
     @savedCase.each_with_index { |e, i|
      if e.keys.include?(caseName)
        retIdx << i
      end
    }
    retIdx 
  end #def sr_dumpCase( caseName }"

  #...............
  def load_NamedCase_Err(caseName, msg)
  #...............
    puts "#!!-- Err load_NamedCase"
    puts "#!!--case'#{caseName}' " + msg 
    puts "#...keys ..."
    @savedCase.each {|hsh| print "  '", hsh.keys,"'\n" }
  end #  def load_SeqErr()

  
  #..........................
  def load_NamedCase( caseName, toSave = true  )
  #..........................
    puts "#def load_NamedCase( #{caseName} )"
    cases = sr_dumpCase( caseName )
    case cases.size
    when 0
      load_NamedCase_Err(caseName, ' Not Saved')
      return nil
    when 1
      cs=load_Case( @savedCase[cases[0]][ caseName ] )
      seq_ = Marshal.load( @savedSeqWrkr[ cases[0] ])
      if seq_ == nil
        load_NamedCase_Err(caseName,'seq_workers Data')
        return nil
      end
      if toSave
        @wrkdays = cs if cs
        @seq_workers = seq_
      end
    else
      # saisin
      cs=load_Case( @savedCase[ cases[-1]][ caseName ] )
      seq_ = Marshal.load( @savedSeqWrkr[ cases[-1] ])
      if seq_ == nil
        load_NamedCase_Err(caseName,'seq_workers Data')
        return nil
      end
      if toSave
        @wrkdays = cs if cs
        @seq_workers = seq_
      end
    end # case
    return cs
    
  end #def load_NamedCase(caseName)
    
  #-----------------------------
  def save_Case(nameCase ='noname')

    #-----------------------------
    puts "#def save_Case  size #{@isInitState}"    
    prevCase = Marshal.dump( @wrkdays )
    @savedCase << { nameCase => prevCase}
    prevSeq = Marshal.dump( @seq_workers )
    @savedSeqWrkr  <<  prevSeq
  end # def save_Case
  
  #-----------------------------
  def load_Case(dumped_Marshal= nil, *param)   # *params Pop
  #----------------------------
    puts "#def load_Case()"
    if dumped_Marshal == nil
    # load Previous which was recently saved
      prevCase = @savedCase[-1]
      if prevCase == nil
        puts "#!! load_Case DO Nothing!!  'PrevCase==nil' )"
        saved = nil
      else
        prkey= @savedCase[-1].keys[0]
        dump_Dat = @savedCase[-1][prkey]
        saved = Marshal.load( dump_Dat )
        @seq_workers = Marshal.load(@savedSeqWrkr[-1])
        if param[0] != nil && param[0] == true
          @savedCase.pop
          @savedSeqWrkr.pop
        end
      end
    else
      # for Only load,  seq_workers is  unrelated
      saved = Marshal.load( dumped_Marshal )
    end
    saved
  end # def load_Case(case_Marshal)

  def CasePop(num)
    num.times{ @saved_Case.pop }
  end

  def CaseShift(num)
    num.times{ @saved_Case.shift }
  end

  
  #-----------------------------
  def load_PrevCase(isDel=true)
  #-----------------------------
    puts "#def load_PrevCase( #{isDel} )"
    #  current to Prev 
    cur_Case = @savedCase.pop
    cur_Seq = @savedSeqWrkr.pop
    #
    prevCase = @savedCase[-1]
    if prevCase == nil
      puts "#!! load_Case DO Nothing!!  'PrevCase==nil' )"
      saved = nil
    else
      prkey= @savedCase[-1].keys[0]
      dump_Dat = @savedCase[-1][prkey]
      saved = Marshal.load( dump_Dat )
#      @wrkdays = saved if saved
      @seq_workers = Marshal.load(@savedSeqWrkr[-1])
      if isDel
        @savedCase.pop
        @savedSeqWrkr.pop
      end
    end
    saved
  end # def load_PrevCase(isDel=true)
  
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


  def test_load_saveCase()
  #
   puts "#### Go Back to beginning"
   cnt =  0
   caseS  = load_Case
    while caseS != nil
      @wrkdays = caseS
      puts "prev Case"
      hor_show(false)
      caseS  = load_Case
      cnt += 1
      break if cnt > 15
    end
    puts "#### END Go Back to beginning"

#    puts "#### "
  end
 
end # module FakeSystem

