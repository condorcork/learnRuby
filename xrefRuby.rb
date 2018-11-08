#!/usr/bin/env ruby
# coding: utf-8
# xrefRuby.rb
#   soft link  --> ~/my_bin/
########################################
# SPEC :
#     ^__END__
#     ^=begin  ^=end
#     skip reserved word
#     
# BUG :
#    word selection
#    not catched --> evenif lose , better than uncatched
#    one char var --> uncatched ?
# To DO
#   File Name  display
#
#  ===== XREF (filename) ====   <====
#  @initCase               [892]   905    906 
#  @month_16           	    105    109    112    117    118    273    826 
#         :
#  ===== End of XREF (filename) ====  
#       ||
#      \||/
#       \/
#       ..
#  ===== XREF < filename > < filename2 > ==== 
#  @initCase  :filename:    [892]   905    906 
#             :filename2:     52     58    168    170 
#  @month_16  :filename:     105    109    112    117    118    273    826
#        :
#  lines      :filename:     [36]   146
#        :
#  ===== END XREF  < filename > < filename2 > ==== 
########################################
$debug = 0
$show_orgData

#................................
def addWord(wd, posRef, def_word=false)
#................................
  if @words[ wd ] == nil
    @words[ wd ] = {}
    @words[ wd ][:ref] ||= {}
    @words[ wd ][:defined] ||= {}
    @words[ wd ] = {}
    @words[ wd ][:ref] ||= []
    @words[ wd ][:defined] ||= []   # prepare for Not UNiq
  end
  #
  @words[ wd ][:ref] << posRef
  @words[ wd ][:defined] << def_word
end

#................................
def mkReserved()
#................................
  @reserved=%w[ if then else unless case when for each each_line do begin end true false nil ]
  @reserved << %w[ def return exit break exit ]
  @reserved << %w[ is_a kind_of to_a to_s to_i to_c to_f downcase upcase ]
  @reserved << %w[ Time Date File Array Hash new clone dup ]
  @reserved << %w[ sort sort_by split join include require ]
  @reserved << %w[ puts print in chop push pull ]
  # attr_accessor 
  @reserved.flatten!
#  p @reserved
end

#................................
def make_dic(wds)   # , lines)
#................................
  lines= ARGF.read

  @dic=@words.sort
  show_dic(@dic, )
  lnum=0
  lines.each_line {|l|
    lnum+=1
    l.chop!
                if $show_orgData == 1
                  puts l
                end
    if l =~ /^__END__/
      break
    end
    def_word=""
    #    if l =~/^[ \t]*def[ \t]+([A-Za-z_]*[A-Za-z][A-Za-z0-9_]+)(\(.*\)|[ \t])*.*/
    #   for one char def action  --> note : wd
    if l =~/^[ \t]*def[ \t]+([A-Za-z_]*[A-Za-z][A-Za-z0-9_]*)(\(.*\)|[ \t])*.*/
      def_word = $1
    end
                   if $debug > 0    
                     puts "============== #{lnum} :#{l}==="
                   end  
    l.gsub!(/^[\t ]*\#.+/,"")    
                   if $debug > 0    
                     puts "====== del ^[\\t ]*'#' ==== #{lnum} :#{l} ==="
                   end
    
    l.gsub!(/(puts|print)[\t ]+"([^"]+)"/,"")
                  if $debug > 0    
                    puts "====== del \"...\"  ====== #{lnum} :#{l} ==="
                  end    
    l.gsub!(/#+[^#]+$/,"")    
                  if $debug > 0    
                    puts "====== del /#+[^#\{]+$/ =$$$=== #{lnum} :#{l} ==="
                  end
     l.gsub!(/'([^']+)'/,"")
                 if $debug > 0    
                   puts "====== del \'...\'  ====== #{lnum} :#{l} ==="
                 end
    #  wd=l.scan(/[@A-Za-z_]*[A-Za-z][A-Za-z0-9_]+/)
    #  for one char vars    --> cf def 'name' too
    wd=l.scan(/[@A-Za-z_]*[A-Za-z][A-Za-z0-9_]*/)
    done=false
    #  wd.each_with_index {|word, i|   for only display 
    wd.each {|word|
                 if $debug > 0
                    puts "    wd='#{word}'     def_word='#{def_word}'"
                 end
      if word =~ /^#/
        break;
      else
        if ! @reserved.include?(word)
          addWord(word, lnum, word == def_word)
                 if $debug > 0          
                   puts "    '#{l}'     def_word='#{def_word}'"
                   puts "  Added #{word} #{word == def_word} "   ##:(#{wds[word][:ref]})"
                 end
        end
      end
    }
  }
end

def show_dic(dic, file=nil)
#  puts "==== XREF << #{file} >> ==="
  dic.each {|k, v|
    printf " %-13s :%-12s:\t", k , file  # , "\t"   ## , v, "\n"
    v[:ref].each_with_index {|ref, i|
      strRef = ref.to_s
      if v[:defined][i] == true
        strRef = "[#{strRef}]"
      else
        strRef = " #{strRef} "
      end
      if strRef.length < 6
        strRef = ' ' * ( 6  - strRef.length ) + strRef
      end
      print strRef      
    }
    puts
  }
#  puts "==== END  XREF << #{file} >> ==="
end




case ARGV[0]
when '-h', '--help'
  puts "xref "
  puts "Xref  file"
  exit 1;
end

#
#words = Hash.new()
#
#words[:word]=[]
#words[:defined]=[]
#words[:ref]=[]
n=0
n+=1
@words = Hash.new()
mkReserved()
make_dic(@words)   # ,xref=true)
  #
@dic=@words.sort
show_dic(@dic, ARGF.filename)
exit 0
####

=begin
p ARGV
ARGF.each {|file|
#  puts argv
#  ARGV.replace [ argv ]
  p file.filename
#  files << argv
#  lines=File(argv).read
#  puts lines
}
=end

=begin
for i in 1..3 do
  lines = ARGF.read # .scan(/[:@A-Za-z]*[A-Za-z][A-Za-z_]+/)
  
  make_dic(@words, lines)   # ,xref=true)
  #
  @dic=@words.sort
  show_dic(@dic, )
end
=end

__END__
##@words[:word] ||= {}
addWord('daysOnMonth', n, 0)
n+=1
addWord('@month_16', n, 0)
n+=1
addWord('@year_16', n, 0)
n+=1
addWord('daysOnMonth', n, 0)
n+=1
addWord('cnt_days', n, 0)
n+=1
addWord('cnt_days', n, n)
puts "\n\n======================"
@words.keys.map{|k|
  print  k," "; print "  refed ",  @words[k][:ref], " "; 
  print "  def ", @words[k][:defined];
  puts 
}
exit
puts "######################"
 @words.keys.map{|k, v|   p k; p v }
 ary=@words.to_a
 print "======\nTo Array "; p ary

 ary.sort!
 print "======\n Array Sort"; p ary
 
 puts "==words==="
 p @words
puts "===dic=="
dic = @words.sort
p dic
#
puts "Array print"
@words.each{|item|
  p item
  p item[:word]
  item.each {|k|
    puts " #{k}" #  ==>#{v}"
  }
}

#mk_dir(
  __END__


exit 0

__END__

@words[ 'daysOnMonth' ]  ||= {}
  @words[:word][ 'daysOnMonth' ][:ref] ||= {}
  @words[:word][ 'daysOnMonth' ][:defined] ||= {}
  #
  words[:word][ 'daysOnMonth' ][:ref]=[]
#  words[:word][ 'daysOnMonth' ][:defined] = {}

#  words[:word][ 'daysOnMonth' ][:ref] = 
end  

#words[:word][ 'daysOnMonth' ][:defined] ||= {}
#

#words[:ref] ||= {}
#words[:ref] << n
#words[:ref] ||= {}
#words[:defined] ||= {}
#words[:defined] << 0
p words
exit








###
#reserved.sort!

#File.open("./main-core.rb", mode = "rt"){|f|
#File.open("../RegExp.rb", mode = "rt"){|f|
#File.open("./Xref.rb", mode = "rt"){|f|
make_dic(words, reserved)
sorted =  words.sort{ |a,  b| a[0] <=> b[0] }
puts
puts "#..... after sort ....."
puts
sorted.each {|w,n|
#words.each {|w,n|
  puts "#{w}\t ===> #{n}"
}
puts "#..... End of Prog ....."


__END__
lnum=0
while line = ARGF.gets
    line.chop!
    lnum+=1
    cnt=0
    puts "============== #{lnum} :#{line}==="
    line.gsub!(/^[\t ]*\#.+/,"")    
    puts "============== #{lnum} :#{line}==="
    wd=line.split(/[:|-|=|\)|\(|,|.| |\t|\]|\[|"|?]+/)
    p wd
    wd.each_with_index{ |w, i|
      if w =~ /^#/
        break;
      else
        print "  " if i == 0
        print "#{w} "
        words[w]+= 1
      end
      puts
     }
=begin    
    puts "============== #{lnum} :#{line}==="
    line.gsub!(/^[\t ]*\#.+/,"")
    puts "============== #{lnum} :#{line}==="
    line.gsub!(/"([^"]+)"/,"")
    puts "============== #{lnum} :#{line}==="
    while line.sub!(/(@*[A-Za-z][A-Za-z_]*[A-Za-z_0-9]*)/, "")
      word = $&;
      puts "  '#{word}'"
      if ! reserved.include?(word)
        words[word]+= 1
        puts "   '#{word}'  count=#{words[word]}"
      end
    end
=end
end
p "=== end of making Dic  =="
p words


sorted =  words.sort{ |a,  b| a[0] <=> b[0] }
puts "# afer sort"
sorted.each {|w,n|
#words.each {|w,n|
  puts "#{w}\t ===> #{n}"
}
#exit #[=

words.sort_by{ |word, count| [-count, word] }.each do |word, count|
  print "#{word}\t#{count}\n"
end

__END__

File.open("./corelogic.rb", mode = "rt"){|f|
  lnum=0
  f.each_line{|line|
    line.chop!
    lnum+=1
    cnt=0
    puts "============== #{lnum} :#{line}==="
    while line.sub!(/(@*[A-Za-z][A-Za-z_]*[A-Za-z_0-9]*)/, "")
      word = $&;
      puts "  '#{word}'"
      if ! reserved.include?(word)
        words[word]+= 1
        puts "   '#{word}'  count=#{words[word]}"
      end
    end
=begin    
    n=line.match(/(\w+|@\w+)/)
    if n > 0 then
         ss=word.captures
         ss.each {|word|
      
      #    line.split(/\W+/).each{|word|
#      puts "'#{word}'"
#      if word.empty?
#        puts "## skip Empty Error '#{word}' in #{line} line.#{lnum}"
      #      else
#      p word
      puts "word '#{word}'"
=end
=begin
      p word.kind_of?(String)
      p word.kind_of?(Array)
      p word.kind_of?(Hash)
      p word.kind_of?(MatchData)
      p "Class=", word.class
=end
=begin
        if word.is_a?(Integer)  # or kind_of?
          #    if ! word.is_integer?
          puts "## skip integer '#{word}' in #{line} in #{line} line.#{lnum}"
        else
          if word =~/\#/
            puts "Error  #{word} in#{line}  in #{line} line.#{lnum}"
          end
          if reserved.include?(word)
            puts "## skip included  '#{word}' in#{line} in #{line} line.#{lnum}"
          else 
            words[word]+=1
          end
        end
#      end  
         }
    end
=end
  }
}

#words.sort_by{|word,count| [-count,word]}.each do |word,count|
#wd= words.sort
#wd.each
#words.each{|word, count|
#print "#{word}\t #{count}\n"
#}

p words


sorted =  words.sort{ |w, n| w[0] <=> w[0] }
puts "# afer sort"
sorted.each {|w,n|
#words.each {|w,n|
  puts "#{w} -> #{n}"
}
exit #[=
words.sort_by{ |word, count| [-count, word] }.each do |word, count|
  print "#{word}\t#{count}\n"
end

