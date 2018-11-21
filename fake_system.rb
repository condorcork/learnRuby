# coding: utf-8

module FakeSystem
  #-----------------------------
  def save_Case(isInitState=false)
    #-----------------------------
    puts "#def save_Case  size #{@isInitState}"    
    @prevCase = Marshal.dump( @wrkdays )
  end
  
  #-----------------------------
  def load_Case(case_Marshal=nil)   # case (Marshal.dump)
  #----------------------------
    puts "#def  load_Case( case_Marshal )"
    if case_Marshal == nil
      if @prevCase == nil
        puts "#!! load_Case DO Nothing!!  'case_Marshal==nil' )"
        nil
      else
        Marshal.load( @prevCase )
      end
    else
      Marshal.load( case_Marshal )
    end
  end # def load_Case(case_Marshal)   # case (Marshal.dump)

  #----------------------------
  def copy_Data( src, target)
  #----------------------------
    puts "# def copy_Data( src, target)"
    target = marshal.load( marshal.dump( src ) )
  end # def copy_Data( src, target)
  
end
