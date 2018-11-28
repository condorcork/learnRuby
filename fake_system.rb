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
    @savedSeqWrkr = []
#    @savedCase << {"ADDASDAD" => dump'}
#    @savedCase << {"noname" => dump'}
#    p @savedCase
    
  end #def init_fake()

#;- no test  
  #...........................
  def sr_dumpCase( caseName )
  #...........................
    puts "#def sr_dumpCase( caseName }"
    retIdx = []
     @savedCase.each_with_index { |e, i|
      if e.keys.include?(caseName)
        retIdx << i
      end
    }
    retIdx 
  end #def sr_dumpCase( caseName }"

  
  #..........................
#  def load_theCase(caseName)
  def load_NamedCase( caseName )
  #..........................
    puts "#def load_NamedCase(caseName)"
    cases = sr_dumpCase( caseName )
    case cases.size
    when 0
      puts "#!! --- Error  load_theCase"
      puts "#!! --- case '#{caseName}' NOT SAVED)"
      puts "#...keys ..."
      @savedCase.each {|h| print "  '", h.keys,"'\n" }
      return nil
    when 1
      cs=load_Case( @savedCase[cases[0]][ caseName ] )
    else
      # saisin
      cs=load_Case( @savedCase[ cases[-1]][ caseName ] )      
    end # case
    return cs
  end #def load_theCase"
    
  
  #-----------------------------
  def save_Case(nameCase ='noname')
    #-----------------------------
    puts "#def save_Case  size #{@isInitState}"    
    prevCase = Marshal.dump( @wrkdays )
    @savedCase << { nameCase => prevCase}
    prevSeq = Marshal.dump( @seq_workers )
    @savedSeqWrkr <<  prevSeq
  end #def save_Case
 
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
  
  #-----------------------------
  def load_Case(dumped_Marshal=nil)
  #----------------------------
    puts "#def  load_Case( case_Marshal )"
    if dumped_Marshal == nil
      # load Previous which was recently saved
      prevCase = @savedCase[-1]
      if prevCase == nil
        puts "#!! load_Case DO Nothing!!  'dumped_Marshal==nil' )"
      #  nil
      else
        prkey= @savedCase[-1].keys[0]
        dump_Dat = @savedCase[-1][prkey]
        saved = Marshal.load( dump_Dat )
        #  seq
        @seq_workers = Marshal.load( @savedSeqWrkr[-1] )
        # need pop?
        @savedCase.pop
        @savedSeqWrkr.pop
      end
=begin        
+=> [{"noname"=>"Noname 1"}, {"noname"=>"Noname 2"}, {"Init"=>"Init 1"}]
+irb(main):067:0> m[-1][mk]
+=> "Init 1"
+irb(main):068:0> 
+=> "Init"
+irb(main):069:0> m[-1][mk]
s||A+=> "Init 1"
=end
#[-        @savedCase.pop  # when delete 
#      end
    else
      saved = Marshal.load( dumped_Marshal )
   #   @seq_workers = Marshal.load( @savedSeqWrkr[-1] ) #[- yet
    end
    saved
  end # def
      ##

=begin      
      if @prevCase == nil
        puts "#!! load_Case DO Nothing!!  'dumped_Marshal==nil' )"
        nil
      else
        saved = Marshal.load( @prevCase )
#[-        @savedCase.pop  # when delete 
      end
    else
      saved = Marshal.load( dumped_Marshal )
    end
    saved
  end # def load_Case(case_Marshal)   # case (Marshal.dump)
=end
  
=begin
+      # load Previous which was recently saved
+      prevCase = @savedCase[-1]
+      if prevCase == nil
+        puts "#!! load_Case DO Nothing!!  'dumped_Marshal==nil' )"
+        nil
+      else
+        prkey= @savedCase[-1].keys[0]
+        dump_Dat = @savedCase[-1][prkey]
+        saved = Marshal.load( dump_Dat )
+        #  seq
+      end
+=begin        
+=> [{"noname"=>"Noname 1"}, {"noname"=>"Noname 2"}, {"Init"=>"Init 1"}]
+irb(main):067:0> m[-1][mk]
+=> "Init 1"
+irb(main):068:0> 
+=> "Init"
+irb(main):069:0> m[-1][mk]
+=> "Init 1"
+=end
+#[-        @savedCase.pop  # when delete 
+#      end
+    else
+      saved = Marshal.load( dumped_Marshal )
+    end
+    saved
+  end # def
=end
  
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
      puts "#{i += 1}: #{key.inspect} キーが押されました。"
    end
  end # def getchar()
=end


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
    end
    puts "#### END Go Back to beginning"
  end
 
end # module FakeSystem
