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
    puts "#def save_Case  #{@nameCase}"    
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
 #   print "*** in (load_Case). object-id='", @wrkdays.object_id, "'\n"
        @seq_workers = Marshal.load(@savedSeqWrkr[-1])
 #   print "*** 2. in (load_Case). object-id='", @wrkdays.object_id, "'\n"
        if param[0] != nil && param[0] == true
          puts "# DONE load_Case"
          my_Pop
#   print "*** 2. in (load_Case). object-id='", @wrkdays.object_id, "'\n"
          
#          @savedCase.pop
#          @savedSeqWrkr.pop
        end
      end
    else
      # for Only load,  seq_workers is  unrelated
      saved = Marshal.load( dumped_Marshal )
    end
#  print "*** in (load_Case).  saved (return) object-id='", saved.object_id, "'\n"
    saved
  end # def load_Case(case_Marshal)

  def CasePop(num)
    num.times{ @saved_Case.pop }
  end

  def CaseShift(num)
    num.times{ @saved_Case.shift }
  end

  def all_SavedCase(isVerbose=true)
    if isVerbose
      puts "saved size  Case = #{@savedCase.size}  seqSaved = #{@savedSeqWrkr.size}"
    end
    
    (0...@savedCase.size).each{|idx|
      puts "No.#{idx}  key"
      @savedCase[idx].keys.each {|k|
        print "   k='#{k}' -> '"
        if @savedCase[idx][k] ==nil
          puts "NIL' Error"
        else
          puts ' some_Dump'
        end
      }
    }
  end # all_SavedCase

  def all_SavedSeq(isVerbose=true)
    if isVerbose
      puts "saved size  Case = #{@savedCase.size}  seqSaved = #{@savedSeqWrkr.size}"
    end
    (0...@savedSeqWrkr.size).each {|idx|
      if @savedSeqWrkr[idx] == nil
        puts "Error !!Seq Saved #{idx} nil"
      else
        puts "No.#{idx} -> some seq dump"
      end
    }
  end # all_SavedSeq

  
  #-----------------------------
  def load_PrevCase(isDel=true)
  #-----------------------------
    puts "#def load_PrevCase( #{isDel} )"
    #  current to Prev 
 #   cur_Case = @savedCase.pop
 #   cur_Seq = @savedSeqWrkr.pop
    #
#    prevCase = @savedCase[0]
    prevCase = @savedCase[-1]
    if prevCase == nil
      puts "#!! load_Case DO Nothing!!  'PrevCase==nil' )"
      saved = nil
    else
      prkey= @savedCase[-1].keys[0]
      dump_Dat = @savedCase[-1][prkey]
#      prkey= @savedCase[0].keys[0]
#      dump_Dat = @savedCase[0][prkey]
      saved = Marshal.load( dump_Dat )
#      @wrkdays = saved if saved
      @seq_workers = Marshal.load(@savedSeqWrkr[-1])
puts "## Done laod_PreCase : check Shifted"
      if isDel
###        my_Shift
#        p @savedCase.shift
#        p @savedSeqWrkr.shift
#         @savedCase[-1,1]=[]
#        @savedSeqWrkr[-1,1]=[]
#        @savedCase.pop
        #        @savedSeqWrkr.pop
        my_Pop
        puts "$$ PrevCase pop"
        all_SavedCase
        all_SavedSeq
     end
    end
    saved
  end # def load_PrevCase(isDel=true)

=begin  
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
=end
  

  #;- no test  
  #----------------------------
  def copy_Data( src )
  #----------------------------
    puts "# def copy_Data( src, target)"
    target = Marshal.load( Marshal.dump( src ) )
  end # def copy_Data( src )
  
  # 
  #......................
  def test_load_saveCase()
  #.......................
    puts '#def test_load_daveCase'
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
 

  def my_Pop()
    puts "## def my_pop"
    all_SavedCase
    saved=[]
    if @savedCase.size > 0
      last = @savedCase.size - 1
      (0...@savedCase.size).each {|idx|
        if idx < last
          saved <<  @savedCase[idx]
        end
      }
      @savedCase = saved
    end
    puts "#!! After my Pop"
    all_SavedCase
    #

    puts "## my SEQ pop"
    all_SavedSeq
    saved_seq=[]
    if @savedSeqWrkr.size > 0
      last = @savedSeqWrkr.size - 1
      (0...@savedSeqWrkr.size).each {|idx|
        if idx < last
          saved_seq << @savedSeqWrkr[idx] 
        end
      }
      @savedSeqWrkr = saved_seq 
    end
    puts "#!! After my Pop"
    all_SavedSeq
  end # my_pop

end # module FakeSystem
