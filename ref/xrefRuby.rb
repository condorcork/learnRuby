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
#
#  ===== END XREF  < filename > < filename2 > ==== 
########################################
$debug = 0
$show_orgData = 0

#................................
#def addWord(wd, posRef, def_word=false)
def addWord(wd, file, posRef, def_word=false)
#................................
  print "# addWord( wd='",  wd , "',  file='",  file,  "',  posRef='" ,posRef,  "',  def_word='",  def_word,    "' )\n"
  wd.each do |k, def_|
    print "# word `", k, "'   defined `", def_, "'\n" 

    print "@words[ k }=`", @words[ k ], "'`\n"
    if @words[ k ] == nil
      @words[ k ] = {}
      p @words
      @words[ k ][file] ||= {}
      p @words
      @words[ k ][file][:ref] ||=[]
      p @words
      @words[ k ][file][:defined] ||=[]
      p @words
    end
    #
    @words[ k ][file][:ref] << posRef
      p @words[ k ]
    @words[ k ][file][:defined] << def_word
    p @words[ k ]
    print "\n\n\n"

  end
=begin    
  if @words[ wd ] == nil
    @words[ wd ] = {}
    @words[ wd ][file] ||= {}
    @words[ wd ][file][:ref] ||=[]
    @words[ wd ][file][:defined] ||=[]
  end
  #
  @words[ wd ][file][:ref] << posRef
  @words[ wd ][file][:defined] << def_word
=end
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

def found_word(line)   # , lnum)
  line.chop!
  words=[]
  if $show_orgData == 1
    puts line
  end
  if line =~ /^__END__/
    return words;
  end
  def_word=""
  #    if line =~/^[ \t]*def[ \t]+([A-Za-z_]*[A-Za-z][A-Za-z0-9_]+)(\(.*\)|[ \t])*.*/
  #   for one char def action  --> note : wd
  if line =~/^[ \t]*def[ \t]+([A-Za-z_]*[A-Za-z][A-Za-z0-9_]*)(\(.*\)|[ \t])*.*/
    def_word = $1
  end
  if $debug > 0    
    puts "============== #{lnum} :#{line}==="
  end  
  line.gsub!(/^[\t ]*\#.+/,"")    
  if $debug > 0    
    puts "====== del ^[\\t ]*'#' ==== #{lnum} :#{line} ==="
  end
  
  line.gsub!(/(puts|print)[\t ]+"([^"]+)"/,"")
  if $debug > 0    
    puts "====== del \"...\"  ====== #{lnum} :#{line} ==="
  end    
  line.gsub!(/#+[^#]+$/,"")    
  if $debug > 0    
    puts "====== del /#+[^#\{]+$/ =$$$=== #{lnum} :#{line} ==="
  end
  line.gsub!(/'([^']+)'/,"")
  if $debug > 0    
    puts "====== del \'...\'  ====== #{lnum} :#{line} ==="
  end
  #  wd=line.scan(/[@A-Za-z_]*[A-Za-z][A-Za-z0-9_]+/)
  #  for one char vars    --> cf def 'name' too
  wd=line.scan(/[@A-Za-z_]*[A-Za-z][A-Za-z0-9_]*/)
  done=false
  #  wd.each_with_index {|word, i|   for only display 
  wd.each do|word|
    if $debug > 0
      puts "    wd='#{word}'     def_word='#{def_word}'"
    end
    if word =~ /^#/
      return words;
    else
      if ! @reserved.include?(word)
        #        words << { word =>  ( word == def_word)  }
        print "def_word '", def_word, "'\n"
        words << { word => ( word == def_word ) }
        puts "--- mkword "
        p words
        puts "--- end mkword "
      end
    end
  end   # wd.each
  print "--- ENd of found_words ---", words, "\n"
  p words
  words
end

#................................
def make_dic(wds) 
#................................
  @files = ARGV
  p @files
  @files.each do |f|
    print "\n\n==== ",f, "\n"

    lnum = 0
    File.open(f).read.each_line do |line|
      lnum+=1
      print line
      words = found_word(line)
      print "foundword '", words, "'\n"
      words.each {|k, v|
        k.each {|word, def_|
          print " word=`", word, "'  def_=`", def_,  "'\n"
          puts
        }
=begin        
        addWord(word, f, lnum, defined )
#        if $debug > 0          
          puts "    '#{line}'     def_word='#{defined}'"
          puts "  Added #{word} #{:word} "   ##:(#{wds[word][:ref]})"
          #        end
=end          
      }
    end
  end
end  # def   
=begin  
  #  @dic=@words.sort
#  show_dic(@dic, )
  lines= ARGF.read
  lines.each 
  lnum=0
  lines.each_line do |l|
#=begin    
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
          addWord(word, file, lnum, word == def_word)
          if $debug > 0          
            puts "    '#{l}'     def_word='#{def_word}'"
            puts "  Added #{word} #{word == def_word} "   ##:(#{wds[word][:ref]})"
          end
        end
      end
    }
  end
#=end  
  print "====>",ARGF,"\n"
end
=end

def show_dic(dic)
  #  puts "==== XREF << #{file} >> ==="
  print "dic size (num of words =", dic.size, "\n"
  dic.each_with_index do |entry, i|
#    dat = entry
    print "==> '", entry, "\n"
    if entry.size > 2
      p entry
      p "file ",entry[0], "\'n"
      entry.each_with_index do |v, i|
        p v[:ref]
        p v[:defined]
      end   
      print " data size ", entry.size,"\n"
    end
    next;
    print "Index=", i, "\n"
    #
    word = entry[0]
    print " word='",word, "'\n"
    entry[1].each do|key, val|
      print " key  :",  key,  "\n"
      print " val  :",  val,  "\n"
      file = key
      p val[:ref]
      p val[:defined]
    end
  end
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
show_dic(@dic)
exit 0
####

=begin
p ARGV
ARGF.each {|file|
#  puts argv
#  ARGV.replace [ argv ]
  p file.filename
#  @files << argv
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
