# coding: utf-8
##
#===  named_captures → hash click to toggle source
##   Returns a Hash using named capture.
#       A key of the hash is a name of the named captures.
#       A value of the hash is a string of [last successful capture] of corresponding group.
                                                                                                                                                              p 'm = /(?<a>.)(?<b>.)/.match("01")'
m = /(?<a>.)(?<b>.)/.match("01")
p m.named_captures #=> {"a" => "0", "b" => "1"}

p 'm = /(?<a>.)(?<b>.)?/.match("0")'
m = /(?<a>.)(?<b>.)?/.match("0")
p nm=m.named_captures #=> {"a" => "0", "b" => nil}

p 'm = /(?<a>.)(?<a>.)/.match("01")'
m = /(?<a>.)(?<a>.)/.match("01")
p m.named_captures #=> {"a" => "1"}

p 'm = /(?<a>x)|(?<a>y)/.match("x")'
m = /(?<a>x)|(?<a>y)/.match("x")
p m.named_captures#=> {"a" => "x"}

=begin
               static VALUE
match_named_captures(VALUE match)
{
    VALUE hash;
    struct MEMO *memo;

    match_check(match);

    hash = rb_hash_new();
    memo = MEMO_NEW(hash, match, 0);

    onig_foreach_name(RREGEXP(RMATCH(match)->regexp)->ptr, match_named_captures_iter, (void*)memo);

    return hash;
}
=end


#######
### names → [name1, name2, ...] 
#    Returns a list of names of captures as an array of strings.
#    It is same as mtch.regexp.names.
#

puts "### names → [name1, name2, ...] "
p '/(?<foo>.)(?<bar>.)(?<baz>.)/.match("hoge").names'
p /(?<foo>.)(?<bar>.)(?<baz>.)/.match("hoge").names
#=> ["foo", "bar", "baz"]

p 'm = /(?<x>.)(?<y>.)?/.match("a") #=> #<MatchData "a" x:"a" y:nil>'
p m = /(?<x>.)(?<y>.)?/.match("a") #=> #<MatchData "a" x:"a" y:nil>
p 'm.names                          #=> ["x", "y"]'
p m.names                          #=> ["x", "y"]


p ""
p ""
=begin
p ' /(?<cmd>(\d|Q)) (?<dir>(+|\-)d+))*(?<day1>d+)*(?<day2>d+)*/.match("hoge")'
p ll=/(?<cmd>(\d|Q))(?<dir>((+|-)\d+)*)(?<day1>(\d+)*)(?<day2>(\d+)*)/.match("1, +2 12 23")
puts "ll=#{ll}"
=end


def parse_dat(line)
  puts   '/^\s*(\d|Q)\s*(,\s*(\-*\d+),\s*(\d+),*\s*(\d+)*)*\s*$/'
'/(\d|Q)(, *(\-*\d+), *(\d+),* *(\d+)*)*/'
  # 1 , +1 5,9,"XXXX"
 /^\s*(\d|Q)\s*(,\s*(\-*\d+),\s*(\d+),*\s*(\d+)*)*\s*$/=~ line
  {cmd_wrkr: $1, direction: $3, day1: $4, day2: $5}
end


#  /^\s*(\d|Q)\s*(,\s*(\-*\d+),\s*(\d+),*\s*(\d+)*)*\s*$/=~ line
#def get_PtrnHash(ptn, hash)
#  /^\s*(\d|Q)\s*(,\s*(\-*\d+),\s*(\d+),*\s*(\d+)*)*\s*$/=~ line

def get_PtrnHash(ptn, hsh)
  puts ptn
  puts hsh
  while true
    puts "======"
    line=gets.chop!
    ret = {}
    if line =~ /#{ptn}/ 
      hsh.each { |k, v|
#        puts " #{k}  -> #{v} : '#{$~[hsh[k]]}'"
        ret[k] = $~[v]
      }
      p ret
      return ret
    end
  end
end
  

  pattern = '^\s*(\d|Q)\s*(,\s*(\-*\d+),\s*(\d+),*\s*(\d+)*)*\s*$'
  puts pattern
  ret = get_PtrnHash(pattern, {cmd_: 1, dire: 3, day1: 4})
  puts ret[:cmd_]=='Q'
      
  p ret
  
