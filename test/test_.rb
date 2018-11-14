def get_OffDays_(dummy)
  @test_ = 1
  wkdaysStr = 'xxx  '*2 *4
  wkdaysStr[10] = ' '
  wkdaysStr[13] = 'x'
  @guide     = '....+....0'*4
  @guide2    = '....$...+....1'
  @guide2 = @guide2 + '...+....2'
  @guide2 = @guide2 + '...+....3'
  @guide2 = @guide2 + '...+.'
  puts wkdaysStr
  puts @guide
  puts @guide2
  wkdays = wkdaysStr.split('')
    @num_days16 = 30
    #
    
    seqs_pos=[]
    days = []
    num_days = 0
if @test_  > 0    
  print '#... wkdays ',wkdays
  puts
end
    (0..@num_days16+4).each{|nth_day|
      if  wkdays[nth_day] == ' '
        days << nth_day
#        num_seq+=1
        num_days+=1
      else
        if num_days > 1
#          seqs=(0...num_seq).map {|n|
#            nth_day - n - 1
#          }.sort
#          seqs_pos << seqs
          seqs_pos << days
        end
        days = []
        num_days=0
       end
    }
    if num_days > 1
      seqs_pos << days
    end
    print "#... Off Seq ",seqs_pos
    puts
    seqs_pos
end


def get_FullOffDays(seqs)
      
  puts "# def get_FullOffDays( #{seqs} )"
    # delete First OffDay 
    seqs_FullOff = seqs.each {|days|
      #days = days[1, 100]  # ?
      #   days.shift
      days
    }
    p 'Only Full Off ...cdar'
    p  seqs_FullOff
    seqs_FullOff.flatten!
    p 'Flatten'
    p seqs_FullOff
    #seqs.flatten!
    
    tmp= seqs_FullOff.reject {|day|
      if ! (4 ... 4+@num_days16).member?(day)
        day
      end
    }
    p "## In Term"
    p tmp
end
  #....................  

  seq_xx = get_OffDays_(1)
  p seq_xx
  
  get_FullOffDays(seq_xx)
