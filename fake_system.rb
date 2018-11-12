# coding: utf-8

module FakeSystem
  #-----------------------------
  def save_Case(isInitState=false)
    #-----------------------------
    puts "# save_Case  size #{@isInitState}"    
    if isInitState
      @initCase=Marshal.dump( @wrkdays )
    else
      @prevCase = Marshal.dump( @wrkdays )
    end
    #    @serCase << @preCase
  end
  
  #-----------------------------
  #  def load_Case(saveNow=false)
  def load_Case(isInitState=false)
    #----------------------------
    puts "#  load_Case(#{isInitState})"
    if isInitState
      if @initCase
        @wrkdays = Marshal.load(@initCase)
      end
    else             
      if @prevCase
        @wrkdays = Marshal.load(@prevCase)
      end
    end
    return
    print  "# load_Case "
    if ! @serCase.empty?
      puts " size #{@serCase.size}"
      #=begin      
      #      if saveNow
      #        nowCase=Marshal.dump( @wrkdays )
      #      end
      @wrkdays = Marshal.load(@serCase.pop)
      #
      #      if saveNow
      #        @serCase << nowCase
      #      end
      #=end
    end
    puts ''
  end

end
