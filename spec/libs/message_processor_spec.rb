require 'helper'

describe Todone::MessageProcessor do
	before(:each) { FSHelp::clean_test_config! }
	describe "self#needs_init?" do
		it "should return true there is no config.yml" do
			Todone::MessageProcessor.needs_init?(FSHelp::CONFIG_DIR).should == true
		end
	
		it "should return false when there is a config.yml" do
			ensure_fresh_config!
			Todone::MessageProcessor.needs_init?(FSHelp::CONFIG_DIR).should == false
		end
	end

	describe "self#init" do
		it "should set owner and api_key when given those options" do
			options = { :dir => FSHelp::CONFIG_DIR }.merge(FSHelp::dummy_config)
			Todone::MessageProcessor.init options
			config = File.open( FSHelp::ABS_CONFIG_FILE ) { |yf| YAML::load( yf ) }
			config.should == FSHelp::dummy_config
		end
		
		it "should return nil if :api_key or :owner arent passed in" do
			options = { :dir => FSHelp::CONFIG_DIR }
			Todone::MessageProcessor.init(options).should == nil
		end
	end

	#TODO remove file work and replace with some stubs	
	describe "#add_project" do
		before(:each) do
			FSHelp::ensure_fresh_config! 
			@mp = Todone::MessageProcessor.new(:config_dir => FSHelp::CONFIG_DIR)
			@project = { :users => 'frank_drebbin', :id => '555555' }
		end
		
		it "should edit a project in config if project is present" do
			@mp.stubs(:add_hook).returns("called")
			@mp.add_project @project
			config = File.open( FSHelp::ABS_CONFIG_FILE ) { |yf| YAML::load( yf ) }
			config.should == FSHelp::dummy_config.merge({:'555555'=> ["frank_drebbin"]})
			@mp.add_project @project
			config = File.open( FSHelp::ABS_CONFIG_FILE ) { |yf| YAML::load( yf ) }
			config.should == FSHelp::dummy_config.merge({:'555555'=> ["frank_drebbin"]})
		end
		
		it "should add a hook to .git/hooks/pre-commit if not present" do
			File.stubs(:exists?).with(File.join('.git','hooks')).returns(true)
			@mp.stubs(:add_hook).returns("called")
			@mp.add_project(@project).should == "called"
		end
		
		#TODO remove text from return statement
		it "should not add a hook if .git/hooks/pre-commit is present" do
			File.stubs(:exists?).returns(true)
			data = @mp.add_project(@project)
			data.shift.should == "exists_pre_commit_hook"	
		end
		
		it "should not add a hook if .git/hooks/ cannot be found" do
			File.stubs(:exists?).returns(false)
			data = @mp.add_project(@project)
			data.shift.should == 'missing_hooks_dir'
		end
	end
	
	describe "#open_tickets" do

		it "should return missing_project_id when pivotal puller has not been set" do
			@mp = Todone::MessageProcessor.new
			data = @mp.open_tickets
			data.shift.should == 'missing_project_id'
		end

		it "should return show_pivotal_stories when stories are returned" do
			@mp = Todone::MessageProcessor.new({:project_id => 5})
			Todone::PivotalPuller.stubs(:get).returns({'stories'=> []})
			data = @mp.open_tickets
			data.shift.should == "show_pivotal_stories"
		end

		it "should return api_problem when an api error" do
			@mp = Todone::MessageProcessor.new({:project_id => 5})
			Todone::PivotalPuller.stubs(:get).raises(SocketError)
			@mp.open_tickets.should == "api_problem"
		end

		it "should return bad_state when passed a non-existant ticket state"

	end
  describe "#write_open_tickets" do
		before(:each) do
			@mp = Todone::MessageProcessor.new({:project_id => 5})
		end

		#TODO: figure out a better way to test this
		it "should write to a file if there are stories and no file is specified" do
			Todone::PivotalPuller.stubs(:get).returns({'stories'=> ['thing']})
			File.expects(:open)
			@mp.write_open_tickets
		end

		it "should not write to a file if there are no stories" do
			Todone::PivotalPuller.stubs(:get).returns({'stories'=> []})
			File.expects(:write).never
			@mp.write_open_tickets
		end

		it "should call a missing_write_file view if a bad write file is specified" do
			@mp.expects(:missing_write_file).returns("")	
			@mp.write_open_tickets :file => 'nonexistant_file_is_nonexistant'
		end 

	end
	
	describe "#commit_msg_file" do
		
		before(:each) do
			@mp = Todone::MessageProcessor.new({:project_id => 5})
		end
	
		it "should return ../COMMIT_EDITMSG if current dir is hooks" do
			Dir.stubs(:getwd).returns('hooks')
			@mp.commit_msg_file.should == '../COMMIT_EDITMSG'			
		end

		it "should return .git/COMMIT_EDITMSG if current dir is base pj dir" do
			Dir.stubs(:exists?).returns(true)
			@mp.commit_msg_file.should == '.git/COMMIT_EDITMSG'
		end
	
		it "Not sure what to do if in a different directory than preious 2"
	end
	
	describe "dynamic view methods" do

		it "should exist if a method exists" do
			Todone::MessageProcessor.method_defined?('open_tickets').should == true
			@mp = Todone::MessageProcessor.new({:project_id => 5})
			@mp.view_open_tickets.class.should == String
		end

		it "should raise a method_missing error if the method does not exist" do
			Todone::MessageProcessor.method_defined?('get_me_a_coke').should_not == true
			@mp = Todone::MessageProcessor.new({:project_id => 5})
	    lambda {@mp.write_get_me_a_coke}.should raise_error NoMethodError
		end

		it "should call the missing template view method when view does not exist" do
			@mp = Todone::MessageProcessor.new({:project_id => 5})
			Todone::MessageProcessor.method_defined?('open_tickets').should == true
			@mp.expects(:missing_view)			
			Todone::Views.stubs(:method_defined?).returns(false)
			@mp.view_open_tickets 
		end

	end
end
