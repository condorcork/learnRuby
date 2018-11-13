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
end

