# coding: utf-8

  def get_(ptn)
    #
    puts ptn
    r=[]
    while true
      puts "----------"        
      line=gets.chop!
      if line=~ /#{ptn}/i
        a = $~[0]
        break if a[0]=='Q'        
        (0..10).each{|x|
          print "No. #{x} '", $~[x], "'\n"
          r << $~[x]
        }
        puts
        puts 'p $~[0]'
        p $~[0]
        p 'all='
        p a
      puts "----------"        
        return r
      end
    end
  end #
 
  #-----------------------------
  def load_Case(*params)   # dumped_Marshal= nil)
  #----------------------------
    puts "#def load_Case()"
    isDel = false
    puts "check class"
    params.each {|x|
      puts x.class
    }
    puts "----------"
    case params.size
    when 0 
      dumped_Marshal = nil
    when 1
      if params[0].kind_of?(String)
        print "<< class ", params[0].class, "\n"
        if params[0] =~ /^DEL$/i
          isDel = true
        else
          dumped_Marshal = params[0]
        end
      elsif params[0].class == TrueClass
        puts ":::::"
        isDel = params[0]
      else
        puts "# load_Case : unknown Params"
        puts "#{params.inspect}"
        return nil
      end
    when 2
      dumped_Marshal = params[0]
      isDel = (params[1] =~/^DEL$/i )
    else
      puts "## load_Case : TOO Many Params"
      puts "#{params.instect}"
      return nil
    end
    puts "# dumped_Marshal --> '#{dumped_Marshal}'"
    puts "# isDel          --> '#{isDel}'"
  end

    
    # marshal to File 
=begin    ### To File 
file = File.open("/tmp/marshaldata", "w+")
Marshal.dump({:a => 1, :b => 3, :c => 5}, file)

# fileポインタが最後の位置にあるので最初から読み込めるように以下を実行
file.rewind
# => 0
Marshal.load(file)
# => {:a=>1, :b=>2, :c=>3}
=end

  
  r=[]
  # 2, 1
  r= get_('(\d|Q|A) *(, *(\d+))*')
  p r 
puts "\nnext"
    r= get_('(\d|Q|A) *(, *(\d+))*')
  p r 
puts "\nnext"
  r= get_('(\d|Q|A) *(, *(\d+))*')
  p r 

  puts "\New"
  r= get_('(\d|Q|A) *(, *(\d+)),2')
  p r 

  
  exit
#
  puts "c = load_Case()"
  c = load_Case()
  puts "ret='#{c}'\n\n"

  puts "c = load_Case('DEL')"
  c = load_Case('DEL')
  puts "ret='#{c}'\n\n"

  puts "c = load_Case('dumpFl')"
  c = load_Case('dumpFl')
  puts "ret='#{c}'\n\n"

  puts "c = load_Case(true)"
  c = load_Case(true)
  puts "ret='#{c}'\n\n"
  
  puts "c = load_Case('dmpFl', true)"
  c = load_Case('dmpFl', true)
  puts "ret='#{c}'\n\n"


=begin  
def func(*param)
  puts "===func==="
  puts "param.size #{param.size}"
  puts param
  p param
  if param[1]=='DEL'
    puts "DELL"
  end
  puts '= Params ==='
  param.each {|x|
    p x
  }
  puts '= Params ==='
puts "---func---"
end



puts "func('A', false, true)"
func("A", false, true)

puts "func('A')"
func("A")

puts "func('', 'DEL')"
func(nil, 'DEL')
=end
