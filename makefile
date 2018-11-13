CoreLogic.rb: corelogic.rb control_helper.rb view.rb fake_system.rb run.rb test_helper.rb ref/include.rb
	ruby control_helper.rb
	ruby view.rb
	ruby fake_system.rb 
	ruby test_helper.rb
	ref/include.rb corelogic.rb >CoreLogic.rb 
	etags  corelogic.rb control_helper.rb view.rb fake_system.rb run.rb CoreLogic.rb 
_taget.rb__: corelogic.rb control_helper.rb view.rb 
	@echo `date` corelogic.rb control_helper.rb view.rb  >_taget.rb
#	@cat _taget.rb

