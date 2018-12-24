# coding: utf-8

require 'io/console'
require 'io/console/size'

def getNum(endMark)
  key = STDIN.getch
  n = key       # n
  while (key = STDIN.getch )!= "\C-c"
    if key == endMark  # ';' / 'm'
      break
    end
    #    y += String( key )  #
    n << key   #
  end
  n.to_i
end

def init_Scrn()
  @maxX, @maxY = scrn_Size()
  clearScrn
  @dat_pos = 0
  goto_x_y(1,1)
end

def clearScrn()
  print "\e[2J"
end


def scrn_Size()
  y,x= IO::console_size
  return x,y
end

def cur_x_y()
  $stdout << "\e[6n"
  $stdout.flush
  res=''
  $stdin.raw do |stdin|
    while (c = $stdin.getc) != 'R'
      res << c if c
    end
  end
  m = res.match /(?<row>\d+);(?<column>\d+)/
  xy={ row: Integer(m[:row]), column: Integer(m[:column]) }
  x=xy[:column]
  y=xy[:row]
  return x, y
end

def x_y_print(x, y, str)
  #print "\e[2J"
    
  print "\e[%d;%dH" % [ y, x ]
  print str
end

def goto_x_y(x, y)
  print "\e[%d;%dH" % [ y, x ]
#  print "\033[7 \033[0m"  #cursor
  @curX=x+1
  @curY=y
end

def goto_Right()
  xy=cur_x_y()
  if xy[0] >= @maxX
    show_data( @dat_pos)
    wait
    @dat_pos += 2
    show_data( @dat_pos)
    wait
    if @dat_pos >= @limit_pos
      @dat_pos = @limit_pos
    end
    show_data( @dat_pos)
    wait
    show_Dat
    goto_x_y(xy[0], xy[1])
  else
    goto_x_y(xy[0]+1, xy[1])
  end
end

def goto_Left()
  xy=cur_x_y()
  if xy[0] == 0
    show_data(@dat_pos)
    if @dat_pos > 0
      @dat_pos -= 2
      if @dat_pos < 0
        @dat_pos = 0
      end
      
      show_Dat
      goto_x_y(xy[0],xy[1])
    end
  else
    goto_x_y(xy[0]-1, xy[1])
  end
end

def show_xy()
  xy=cur_x_y()
  posStr=" pos=(%2d, %2d) " % xy
  x_y_print(12, @maxY, posStr)
  goto_x_y(xy[0], xy[1])
end

def wait()
  STDIN.getch
end

def show_data(dat)
  xy=cur_x_y()
  x=@maxX - " '#{dat}' ".length 
  x /= 2
  x_y_print(1, @maxY, ' '* @maxX)
  x_y_print(x, @maxY, " '#{dat}' ")
  goto_x_y(xy[0], xy[1])
end  

def Init_Dat()
  @hdr=[]
  @hdr[0] = '0 1 2 3|4 5 6 7 8 9 1 . . . . + . . . . 2 . . . . + . . . . 3 . . . . +'

  @dat=[]
  @dat[0]= 'x x x x|x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x'
  @dat[1]= 'x_x____|x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x_x'
  @dat[2]= ' _ _x_x|x_ _ _x_x_x_ _ _x_x_x_ _ _x_x_x_ _x_x_ _x_x_x_ _x_x_ _ _x_x_x_x'

  @dat_pos=0
  @num_days = 31
  # limit to Right
  @limit_pos = (@num_days + 4)*2 - @maxX - 1

  
end

def show_Dat()

  lin=@hdr[0][@dat_pos * 2, @dat_pos*2 + @maxX]
#  if lin.length < @maxX
#    lin += ' '*(@maxX - lin.length)
#  end
  x_y_print(1, 1, lin)
  
  (0..2).each{|i|
    lin=@dat[i][@dat_pos * 2, @dat_pos * 2 + @maxX]
#    if lin.length < @maxX    
#      lin += ' '*(@maxX - lin.length).
#    end
    x_y_print(1, i+2, lin)
  }    
end

def set_Dat(row, column, key)
  # for Debug
  msg="def set_Dat(#{row}, #{column}, #{key})" % [ row, column, key]
  xy=cur_x_y()  
  x_y_print(12, @maxY, msg) 
  goto_x_y(xy[0], xy[1])
  # 
  x=column + @dat_pos - 1
  case row
  when 1
    @hdr[0][x]=key
  when 2..4
    @dat[row-2][x]=key
  else
    puts "Err #{row} not 1..4"
    exit 1
  end
  show_Dat
end

def get_direction(key)
   direction = case key
               when "A", "k", "w", "\u0010"; "A" #↑
               when "B", "j", "s", "\u000E"; "B" #↓
                when "C", "l", "d", "\u0006"; "C" #→
                when "D", "h", "a", "\u0002"; "D" #←
                else nil
               end
   return direction
end

#---- MAIN ----
#read_key
#  read_arrow_key
init_Scrn()
Init_Dat()


#y,x= IO::console_size
#p x, y

# frame corner of window
  x_y_print(1, 1, '+')
  x_y_print(@maxX, 1, '+')
  x_y_print(1, @maxY, '+')
  x_y_print(@maxX, @maxY, '+')
#
  (2...@maxY).each{|y|
    x_y_print(1, y, "%3d" % y)
  }
  
  show_Dat
  goto_x_y(3,10)
  loop do
    key=STDIN.getch
    case key
    when "\C-c";   break
    when "\e"
      if ( nkey=STDIN.getch ) == "["
        key=STDIN.getch
        direct=get_direction(key)
        if direct
          print "\e[#{direct}"
        else
          print key;
        end
      else
        print key
      end
    when "\r"
      print key
    when "\C-e"
      print "#{key}"
    else
      print key
    end 
  end
  exit
  
escpLP=false
while (key = STDIN.getch) != "\C-c"
  # 方向キー以外は不要なので、エスケープ文字を得る処理は簡略化した
  if key == "\e" && STDIN.getch == "["
    escpLP=true
    key = STDIN.getch
  end

  # 方向を判断
 direction = case key
                #              when "A", "k", "w", "\u0010"; "A" #↑
                when "A","\u0010"; "A" #↑
                #  when "B", "j", "s", "\u000E"; "B" #↓
                when "B", "\u000E"; "B" #↓
                when "C", "l", "d", "\u0006"; "C" #→
                #              when "C", "\u0006"; "C" #→
                #  when "D", "h", "a", "\u0002"; "D" #←
                when "D","\u0002"; "D" #←
                else nil
                end

    # カーソル移動
    if direction
      if direction=='C'
        goto_Right
      elsif direction=='D'
        goto_Left
      else
        print "\e[#{direction}"
      end
  else
    case key
    when '?'
      show_xy
    when 'v'
      xy=cur_x_y()
      goto_x_y(xy[0], xy[1]+1)
    when '^'
      xy=cur_x_y()
      goto_x_y(xy[0], xy[1]-1)
    when '<'
      goto_Left()
    when '>'
      goto_Right
    when "\r"
      xy=cur_x_y()
      goto_x_y(0, xy[1])
    else
      xy=cur_x_y()
      print key
      set_Dat(xy[1], xy[0], key)
      goto_x_y(xy[0]+2, xy[1])
    end # case key
  end
end
 
__END__
このままだと大文字のAとかを打った場合にも上下左右に移動してしまいます。
特に支障はないので対応しませんが。

require 'io/console/size'とIO::console_size、今回知ったのですがほとんど使われてませんね。
今までstty sizeでやってました。GitHubでconsole_sizeで検索しても全く使われてないっぽい？

参考
Rubyでバッファリングなしのキー入力を試す - Programmer's Dialy
instance method IO#getch
singleton method IO.console_size
ANSI escape code - Wikipedia
編集リクエスト
ストック
いいね
18
zakuroishikuro
zakuro ishikuro
@zakuroishikuro
フラフラしてます。アイコンお借りしました→http://www.nicotalk.com/ktykroom.html
フォロー



© 2011-2018 Increments Inc.
# coding: utf-8
require 'io/console'
require 'io/console/size'

def scrn_clear
  print "\e[2J"
end


def printStr(str)
  @prevX=@curX
  @prevY=@curY
  print "\033[7#{str}\033[0m"
#  @curX=
end

