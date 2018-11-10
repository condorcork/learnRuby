_taget.rb__: corelogic.rb control_helper.rb view.rb
	@echo `date` corelogic.rb control_helper.rb view.rb >_taget.rb
	@cat _taget.rb
CoreLogic.rb:  corelogic.rb control_helper.rb view.rb
	ref/include.rb corelogic.rb >CoreLogic.rb
	etags  corelogic.rb control_helper.rb view.rb

