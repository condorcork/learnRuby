# coding: utf-8
module TestHelper

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

