CoreLogic.rb: corelogic.rb control_helper.rb view.rb fake_system.rb menu_io.rb run.rb test_helper.rb ref/include.rb
	ruby -c control_helper.rb
	ruby -c test_helper.rb
	ruby -c view.rb
	ruby -c fake_system.rb
	ruby -c menu_io.rb
	ruby -c test_helper.rb
	ref/include.rb corelogic.rb >CoreLogic.rb
	ruby CoreLogic.rb
	etags  corelogic.rb control_helper.rb view.rb fake_system.rb menu_io.rb run.rb CoreLogic.rb
	ruby run.rb

_taget.rb__: corelogic.rb control_helper.rb view.rb
	@echo `date` corelogic.rb control_helper.rb view.rb  >_taget.rb
#	@cat _taget.rb

