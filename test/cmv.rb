# coding: utf-8
require 'io/console'
require 'io/console/size'


def read_key
  i=0
  while (key = STDIN.getch) != "\C-c"
    puts " #{i += 1}: #{key.inspect} キーが押されました。"
    puts " #{i}: #{key}"
  end
#..........  
#方向	エスケープシーケンス
#上	"\e[A"
#下	"\e[B"
#右	"\e[C"
#左	"\e[D"  
#..........  
end

def read_arrow_key()
  
  arrows = {A: "↑", B: "↓", C: "→", D: "←"}

  i = 0
  while (key = STDIN.getch) != "\C-c"

    if key == "\e"
      second_key = STDIN.getch

      if second_key == "["
        key = STDIN.getch
        key = arrows[key.intern] || "esc: [#{key}"
      else
        key = "esc: #{second_key}"
      end
    end
  end
end # read_arrow_key

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
  goto_x_y(1,1)
end

def clearScrn()
  print "\e[2J"
end

def scrn_Size()
  y,x= IO::console_size
  return x,y
end

def show()
  hdr='0 1 2 3|4 5 6 7 8 9 0 '
  hdr << '1 2 3 4 5 6 7 8 9 0 '*2
  hdr << '1 2 3 4 5 '
  x_y_print(0, 0, hdr)
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
  print "\033[7 \033[0m"  #cursor
  @curX=x+1
  @curY=y
end

#
def show_xy
  xy=cur_x_y()
  posStr=" pos=(%2d, %2d) " % xy
  x_y_print(12, @maxY, posStr)
  goto_x_y(xy[0], xy[1])
end

#---- MAIN ----
#read_key
#  read_arrow_key
init_Scrn()

#y,x= IO::console_size
#p x, y

# frame corner of window
  x_y_print(1, 1, '/')
  x_y_print(@maxX, 1, '\\')
  x_y_print(1, @maxY, '\\')
  x_y_print(@maxX, @maxY, '/')
   
#
  (2...@maxY.each{|y|
    x_y_print(1, y, "%3d" % y)
  }

 x_y_print(2, 2, '234567890....+....2....+....3....+....4' +
                  '....+....5....+....6....+....7'+
                  '....+....8....+....9....+....0' +
           '....+....1....+....2....+....2....+....3....+....4')

#画面を消去して、真ん中に移動しておく
#print "\e[2J"
##show
#print "\e[%d;%dH" % IO::console_size.map{|size| size / 2 }
#print "\033[32mSTART\033[0m :"

while (key = STDIN.getch) != "\C-c"
  # 方向キー以外は不要なので、エスケープ文字を得る処理は簡略化した
  if key == "\e" && STDIN.getch == "["
    key = STDIN.getch
  end

  # 方向を判断

  direction = case key
#              when "A", "k", "w", "\u0010"; "A" #↑
              when "A","\u0010"; "A" #↑
#  when "B", "j", "s", "\u000E"; "B" #↓
              when "B", "\u000E"; "B" #↓
  #when "C", "l", "d", "\u0006"; "C" #→
              when "C", "\u0006"; "C" #→
#  when "D", "h", "a", "\u0002"; "D" #←
              when "D","\u0002"; "D" #←
              else nil
              end

  # カーソル移動
  if direction
    print "\e[#{direction}"
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
      xy=cur_x_y()
      goto_x_y(xy[0]-1, xy[1])
    when '>'
      xy=cur_x_y()
      goto_x_y(xy[0], xy[1]+1)
    when "\r"
      xy=cur_x_y()
      goto_x_y(0, xy[1])
    else
      xy=cur_x_y()
      print key
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
利用規約
ガイドライン
プライバシー
ヘルプ
Qiita とは
ユーザー
タグ
記事
ブログ
API
Qiita:Team
Qiita:Zine
広告掲載
ご意見
#
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

