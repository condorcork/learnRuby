# coding: utf-8
module TestHelper


  def test_slide_Part
    slide_Part(0, 2, 9,9)
    show_Hyo(false)
    slide_Part(0, -2, 9,9)
  end 

  def test_copy
    puts "#@@@ TEST tmp= 'copy_Data'(@wrkdays, tempDays)"

    tmp=  copy_Data(@wrkdays)

    print "## @wrkdays '", @wrkdays, "'\n"
    print "##      tmp '", tmp, "'\n"

    if tmp ==  @wrkdays
      puts "## tmp == @wrkdays "
    else
      puts "## tmp !=  @wrkdays "
    end


    tmp[0][0] = 'A'
    print "## @wrkdays '", @wrkdays, "'\n"
    print "##      tmp '", tmp, "'\n"

    
    puts "## tmp = @wrkdays "
    tmp = @wrkdays
    tmp[0][0] = 'A'
    puts "## After tmp[0[0] = 'A'"
    print "## @wrkdays '", @wrkdays, "'\n"
    print "##      tmp '", tmp, "'\n"

    org='B'
    copied = org
    puts " org='#{org}'  copied=' #{copied}'"
    copied = 'C'
    puts " After copied='C'"
    puts "org='#{org}'  copied=' #{copied}'"
    #
    #
    org=@wrkdays
    copied = org
    puts " org='#{org}'  copied=' #{copied}'"
    copied[0][0] = 'XXX'
    puts " After copied='C'"
    puts "org='#{org}'  copied=' #{copied}'"
##
    exit;
  end

  def test_SusMenu
    puts "Sub Menu Test"

    ret = do_Action(45, 0, -2);    # Not sufficient　Params
    puts "ret = #{ret}"
    ret = do_Action(46,1); 
    puts "ret = #{ret}"

    ret = do_Action(40);     # Sub Menu SHow?
    puts "ret = #{ret}"
    ret = do_Action(41);     # got Diret 41
    puts "ret = #{ret}"
    ret = do_Action(42); 
    puts "ret = #{ret}"
    ret = do_Action(43); 
    puts "ret = #{ret}"                                           
    ret = do_Action(44); 
    puts "ret = #{ret}"
#
    ret = do_Action(48);    # Yet
    puts "ret = #{ret}"

    ret = do_Action(49);    # Meanual go
    puts "ret = #{ret}"

#
    ret = do_Action(45, 0, -2);    # Not sufficient　Params
    puts "ret = #{ret}"
    ret = do_Action(46,1); 
    puts "ret = #{ret}"

    ret = do_Action(47);    # Not sufficient　Params
    puts "ret = #{ret}"
    ret = do_Action(48);    # Yet
    puts "ret = #{ret}"

    ret = do_Action(49);    # Meanual go
    puts "ret = #{ret}"

    ret = do_Action(40);    # 'Q'
    puts "ret = #{ret}"
    exit
    
  end

  def test_GoBack
    puts "#def test_GoBack"
    puts '== Saved Case =='
    
    all_SavedCase

    all_SavedSeq
    
    puts "\nTest Go Back"

#    # == (0...@savedCase.size).to_a.reverse
    (0...@savedCase.size).map(&:itself).reverse.each do |idx|
#    (0...@savedCase.size).map(&:itself).each do |idx|
    print "****** reverse 0            object-id='", @wrkdays.object_id, "'\n"
      @savedCase[idx].keys.each do |k|
        if ok_YN?( " '#{idx}'  key ='#{k}' Do?  Y/N/Q" ) == 'N'
          return
        end
    print "****  reverse 1  Before    object-id='", @wrkdays.object_id, "'\n"
        sc = load_Case( @savedCase[idx][k])
    print "*** reverse 2 (load_Case). object-id='", @wrkdays.object_id, "'\n"
        if sc ==nil
          puts "#!! ERRor @savedCase['#{idx}']['#{k}'] ==nil"
        else
          @wrkdays=sc
    print "*** reverse 3 (assigned). object-id='", @wrkdays.object_id, "'\n"
          print "loaded @wrkdays='", @wrkdays, "'\n"
          if @savedSeqWrkr[idx] != nil
            sw =Marshal.load( @savedSeqWrkr[idx] )
            if sw != nil
              @seq_workers = Marshal.load( @savedSeqWrkr[idx] )
              hor_show(false)
            else
              puts "#!! Error Load Err  Marshal.load(@savedSeqWrkr['#{idx}']) == nil"
            end
          else
            puts "#!! Error @savedSeqWrkr['#{idx}'] == nil"
          end
        end 
        ok_YN?("Done loaded key ['#{idx}'] key='#{k}'  NEXT Y:")
        puts ""
      end # @saved..[idx].keys.each 
    end  #(0...@sav..se.size).map(&:itself).reverse.each
#    
#---- GoBackTo origin (only Saved Case)
#  
    while true
      if ok_YN?('PrevCase Y/N:')== false
        puts ' .....'
        break
      end
      sc=load_PrevCase
      
      break if sc ==nil
    print "****** Prev 1. wrkdays object-id='", @wrkdays, "'\n"
      @wrkdays=sc
    print "****** Prev 2. wrkdays object-id='", @wrkdays,  "'\n"
      hor_show(false)
    end 

     test_load_saveCase()
 #   exit
  end
  
  def test_data()
    #xxx[0]="0123|4..................................."
    a = []
    ar=[]
    a[0]  ="XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX"
    a[1]  ="  XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX"
    a[2]  ="   XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX"
    a[3]  =" DDx  DDDD   DDDD   DDDD   DDDD   DDDD   DDD"
#    a[3]  =" XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX"
    (0..3).each {|x|
      p a[x]
      ar[x] = a[x].split("")
      p "==>",ar[x]
      @wrkdays[x]=ar[x]
    }
    puts
    p @wrkdays
  end

  def testMain()
    adjust(0)
  end

  def do_test
    puts 'do_test'
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
    @wrkdays[0][5]='X'
#    sel_ToggleExchange()    
    show_Hyo
    puts 'Get From File '
    file.rewind
    @wrkdays = Marshal.load(file)
    show_Hyo
    puts 'End do_test'
  end
end

