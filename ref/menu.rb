  def sel_MENU()
print <<-EOF
  0: Iniitial
  1: Select PARAM  -- PATERN , Seq 
  2: KOYANO
  3: Manual  :
EOF
    while true
      print ">>"
      ret = gets
      ret.chop!
      if ret =~/^[1239]$/
#        ret.to_i
        return ret.to_i
      end
    end
  end
