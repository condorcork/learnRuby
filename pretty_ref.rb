#!/usr/bin/env ruby
#
prevWd=""
cnt=0
prevDt=[]
#
while l=gets
  l.chop!
puts "\n====="
  puts l
  if l !~ /^===/
#    itm=[] 
    itm = l.split(/[\t ]+/)
#=begin
    if itm[1] > prevWd
      print ">>>>> '",itm[1], " > ", prevWd, "'\n"
      case cnt
      when 0
        ;
      else    #
        puts prevDt[0]
        #
        wd_gap = l.sub(/:[^:]+:[^:]+$/, "")
        print " wd_gap'",  wd_gap , "'\n"
        filler = ' ' * wd_gap.length
        print "len  l=", l.length, "  wd_gap=", wd_gap.length, "\n"
        app_ref_def = l.slice(wd_gap.length-1, 500)
        print "app_ref_def '", app_ref_def,"'"
        puts
        p "================="
        print  l, "\n"
        print "##  wd app ref def '", wd_gap + app_ref_def, "'\n"
        print "       app ref def '", filler + app_ref_def, "'\n"
        print "=================\n"
        
        (1...cnt).each {|i|
          # ' word  :app1:  No1 No2 ....'
          # '       :app2:  No1 No2 ....'
          # '------'
          # wd_gap  '-------------------
          #               app_ref_def
          ln = prevDt[i]
          print "## No. ", i + 1, "\n"
          app_ref_def = ln .slice(wd_gap.length-1, 500)
             print "app_ref_def '", app_ref_def,"'"
          puts
          p "================="
             print  ln, "\n"
             print "   wd app ref def '", wd_gap + app_ref_def, "'\n"
             print "##    app ref def '", filler + app_ref_def, "'\n"
             print "=================\n"
        }
        cnt = 0
        prevWd = l
      end
      prevDt[cnt] = l
      prevWd = itm[1]    # Word 
      cnt += 1
    end

#=end        
=begin
    # p itm
    wd_gap = l.sub(/:[^:]+:[^:]+$/, "")
    print " wd_gap'",  wd_gap , "'\n"
      filler = ' ' * wd_gap.length
      print "len  l=", l.length, "  wd_gap=", wd_gap.length, "\n"
      app_ref_def = l.slice(wd_gap.length-1, 500)
      print "app_ref_def '", app_ref_def,"'"
      puts
      p "================="
      print  l, "\n"
      print " wd app ref def '", wd_gap + app_ref_def, "'\n"
      print "    app ref def '", filler + app_ref_def, "'\n"
      print "=================\n"
print itm[1],  itm[2],  l.sub!(/(#{itm[1]}[\t ]+#{itm[2]})/,"")
#puts
=end
  end
  
end
