def get_OffDays_(dummy)
  @test_ = 1
  #  
  wkdaysStr = 'xxx  '*2 *4
  wkdaysStr[2] = ' '
  wkdaysStr[10] = ' '
  wkdaysStr[13] = 'x'
  #  
  @guide     = '....+....0'*4
  @guide2    = '....$...+....1'
  @guide2 = @guide2 + '...+....2'
  @guide2 = @guide2 + '...+....3'
  @guide2 = @guide2 + '...+.'
  #
  puts @guide
  puts @guide2
  puts wkdaysStr
  puts @guide
  puts @guide2
  #
  wkdays = wkdaysStr.split('')
  @num_days16 = 30 # 1  # 29 # 30
  #

  @theMonthRange = (4 ... 4+@num_days16)


  #---- start Here -----    
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
#  puts "# def get_FullOffDays( #{seqs} )"
  # ---- In Range of the Month
  daysWithFullOff =[]    # array of COnseq 
  seqs.each do|days|
#    puts "Check element daary #{days}"
    days_ =[]
#    puts "# Range #{@theMonthRange}' "
    days.each {|day|
      if @theMonthRange.member?(day)
        days_ << day
      end
    }
#    puts "## days in seq days_ ==> '#{days_}'"
#    puts "## days length ==> '#{days_.length}'"
    case days_.length
    when 1
      if days_[0] == 4
        daysWithFullOff << [ days_.shift ]
      #else
        #  month over  
      end
    when 2, 3, 4
      daysWithFullOff << days_  # array of Kokyu
    when 0
      ;
    else    #  3,4,5.....
      daysWithFullOff << days_  # array of Kokyu
    end
#    puts "## days after removed out of range _ ==> '#{days_}'"
#    puts "## daysWithFullOff '#{daysWithFullOff}'"
  end
#  puts "## daysWithFullOff '#{daysWithFullOff}'"
  #  p #{daysWithFullOff}
   daysWithFullOff
  
end 

=begin
  #----- Flatten array  
    # delete First OffDay 
    seqs_FullOff = seqs.each {|days|
      #days = days[1, 100]  # ?
      days.shift
      #days
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
=end

#..main ..................  

  seq_xx = get_OffDays_(1)
  p seq_xx
  
  result = get_FullOffDays(seq_xx)
  print "=== days WIth Full Off\n"
  p result 
