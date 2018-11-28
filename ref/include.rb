#!/usr/bin/env ruby
# coding: utf-8

#fake include module
#
#------------------------------------
# CAUTION
#   bug 
#  ^end ==> Module END
# ...................................
@cnt_begin = 0
@cnt__END__ = 0

def fakename( fn )
  fn.sub(/([a-z][A-Z])/, "\1_")
  case fn
  when "TestHelper"
    md = "test_helper"
  when "control_helper"
    md = "ControlHelper"
  when "view"
    md = 'View'
  when "ControlHelper"
    md = "control_helper"
  when "View"
    md = 'view'
  when "FakeSystem"
    md = "fake_system"
  when "MenuIo"
    md = "menu_io"
  else
    md = fn
  end
  md + ".rb"
end

##def is_LineSkip(line, cnt_begin, cnt__END__)
def is_LineSkip(line)   # , cnt_begin, cnt__END__ )
#  print "## cnt_begin  =", @cnt_begin, " cnt__END__ =", @cnt__END__
=begin  
  if line =~/^__END__/
    print line
    puts "# followng lines omitted"
    cnt__END__ = 1     # to skip following lines
  elsif cnt__END__ > 0
    cnt__END__ += 1
  else
    if line =~/^=begin/
      #    isSkip = true
      cnt_begin = 1
      print line
    end  
    if cnt_begin > 0
      if line =~/^=end/
        puts "#  #{cnt_begin - 1} lines skipped"
        print l  
        cnt_begin=0
      else
        cnt_begin +=1
      end
    end
  end
  ( cnt__END__ > 0 ) or  ( cnt_begin > 0 )
=end

  if line =~/^__END__/
    print line
    puts "# followng lines omitted"
    @cnt__END__ = 1     # to skip following lines
    return true
  end
  if @cnt__END__ > 0
    @cnt__END__ += 1
    return true
  end
  if line =~/^=begin/
    @cnt_begin = 1
    print line   # puts "=begin"
    return true
  end  
  if @cnt_begin > 0
    if line =~/^=end/
      puts "#  #{@cnt_begin - 1} lines skipped"
      print line  #"=end"
      @cnt_begin=0
    else
      @cnt_begin +=1
    end
    return true
  end
 
  return false
end

#== MAIN ===============
#
#lines=ARGF.read
#lines.each_line {|l|
#
##ARGF.each do |line|
#

  ARGF.each do |line|
#  if line =~ /^include[ \t]+\'\.\/([a-zA-Z_0-9]+)\'/
# print "# DATA # '" + line.chop + "'\n"
 if is_LineSkip(line) # , @cnt_begin, @cnt__END__)
   next 
 end
=begin
 if line =~/^__END__/
    print line
    puts "# followng lines omitted"
    cnt__END__ = 1     # to skip following lines
#    break
  end
  if cnt__END__ > 0
    cnt__END__ += 1
    next
  end
  if line =~/^=begin/
    cnt_begin = 1
    puts "=begin"
    next
  end  
  if cnt_begin > 0
    if line =~/^=end/
      puts "#  #{cnt_begin - 1} lines skipped"
      puts "=end"
      cnt_begin=0
    else
      cnt_begin +=1
    end
    next
    end
=end
 if line =~ /^if @debug_do_Exchange/
   line = l
 end

  if line =~ /^include[ \t]+\'\.\/([a-zA-Z_0-9]+)\'/
    # including
    md=$1
    dir=File.dirname( md )
    file=File.basename( md)
    mdl = fakename( file ) 
    flpath =  dir + '/' +  mdl
    if File.exists?(flpath)
      #----  begin include 
      puts "#=== '#{line.chop}' ===#"
      puts "#=== including < #{mdl} > ==="
#-----      
      File.open(flpath).read.each_line do |l|
        #print "## CHILD ## '" + l.chop + "'\n"
        @cnt_begin = @cnt__END__ = 0

        next if is_LineSkip(l)   #  cnt_begin, cnt__END__ )
        
        case l
        when /^module[ \t]+([A-Z][a-zA-Z0-9_]+)/
          included = $1
          inc_file = fakename( included )
          if inc_file != mdl
            puts "##===== Module name Error '#{inc_file}' : must be #{mdl}"
            print l
            exit;
          end
          print "# '#{l.chop}'\n"
=begin
#       when regexp NOT work !          
        when l =~ /^end[\t ]*/
          print "# #{l.chop!}   of module\n"
          print "# #{l}  # of module\n"
          print "#[ --- Omitted followng file if any  ===#\n"
          break    #[-
=end
        else
          if  l =~ /^end[\t ]*/
            print "#== END #===\n"
            print "#'#{l.chop!}'  ===#\n"
            print "#[ #{l}  # of module\n"
#            break   #[-
          else
            print l    # nomal data
          end
        end
      end
      puts "#=== << #{mdl} >> included"
      #---     end include
      @cnt_begin = @cnt__END__ = 0
#-----      
    else
      puts "#=== < #{mdl} > Not Found ===="
      exit 1
    end
#    print "#", line 
    # included 
  else   # not include line
    print line
  end

end

if @cnt__END__ > 0 || @cnt_begin > 0
  puts "#  #{@cnt__END__ - 1} lines skipped by __END__"
  puts "#__END__"
end
