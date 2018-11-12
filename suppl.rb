 #..............................
  def shift_to(idxWorker, direction=+1)
  #..............................
    # shift right +N, left -N
    puts "#  def shift_to( #{idxWorker}, #{direction} )"    
    strDays = @wrkdays[idxWorker].join('')
    strDays = strDays.slice(4, @num_days16)
    distance = ( direction < 0 ? direction * -1 : direction )

    filler = ' ' * distance    
    if direction > 0
      strDays = filler + strDays
      strDays = strDays.slice(0, @num_days16)
      puts "#----'" + "....+....0"*4
      puts "#--- '#{strDays}'   len=#{strDays.length}"
    else
      strDays = strDays.slice(distance, 33)  + filler
    end
    strDays = @wrkdays[idxWorker].join('').slice(0,4) + strDays
    @wrkdays[idxWorker] = strDays.split('')
  end

  def shift_AI(idx, dir)
    #
    shift_to(idx, dir)
    # Hyouka
    prev = saveCase
 #   others = (0...@num_workers).to_a - [ idx ]
    (4...4+@num_days16).each do |d|
      n = cnt_filled(d)  #, others)
      case n
      when 1, 0
        if @wrkdays[3][d] == ' '
          @wrkdays[3][d] = 'x'
        else
        end
      when 3, 4
        if @wrkdays[3][d] == 'x'
          @wrkdays[3][d] = ' '
        else
        end
      when 2
        ;   # ok
      else
        ;   #  ??
      end
    end  # (4..).each
    # Hyoka
    # compareCase
    # get Better
  end # shift_AI
  
        
        if @wrkdays[3][d] == ' '
          @wrkdays[3][d] = 'x'
        else
        end
        
        ;
        
          :
            
    
    if dir < 0
      start_=4 + @num_days16 - 1
    else
      
    
     @wrkdays[idx]
  end
#control_helper

  #..............................
#   def cnt_filled(idx_day, idx_workers=[0, 1, 2])
1
  #................................
  def cnt_filled(idx_day, idx_workerxs=[0, 1, 2, 3])
  #................................ 
