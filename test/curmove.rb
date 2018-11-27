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

#---- MAIN ----
read_key
#  read_arrow_key


#画面を消去して、真ん中に移動しておく
print "\e[2J"
print "\e[%d;%dH" % IO::console_size.map{|size| size / 2 }
print "\033[32mSTART\033[0m :"

while (key = STDIN.getch) != "\C-c"
  # 方向キー以外は不要なので、エスケープ文字を得る処理は簡略化した
  if key == "\e" && STDIN.getch == "["
    key = STDIN.getch
  end

  # 方向を判断


  direction = case key
  when "A", "k", "w", "\u0010"; "A" #↑
  when "B", "j", "s", "\u000E"; "B" #↓
  when "C", "l", "d", "\u0006"; "C" #→
  when "D", "h", "a", "\u0002"; "D" #←
  else nil
  end

  # カーソル移動
  print "\e[#{direction}" if direction
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


