def get_PtnDat2( ptn, *matchN )
  puts "Enter #{ptn}"
  puts "#{ptn}"
  cs=1
  case matchN.size
  when 2
    case matchN[1]
    when 2
      cs=2
    when 3
      cs=3
    when 4
      cs=4
    end
  end
             
  while true
    l=gets
    if l =~ /#{ptn}/
      x=$1
      case cs
      when 1
        y=nil
      when 2
        y=$2
      when 3
        y=$3
      when 4
        y=$4
      end
      #x= $"#{matchN[0]}"
      return x,y
    elsif l =~ /^Q/i
      return 'Q'
    end
  end
end

while true
 w, d = get_PtnDat2( '(\d),((\+|-)\d+)', 1, 2)
#  w, d = get_PtnDat('(\d)( *,* *(\d+))*',1, 3)
  puts "#{w} #{d}"
  break if w == 'Q'
end
                      
