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
			@mp.add_project(@project).should == "exists_pre_commit_hook"	
		end
		
		it "should not add a hook if .git/hooks/ cannot be found" do
			File.stubs(:exists?).returns(false)
			@mp.add_project(@project).should == 'missing_hooks_dir'
		end
	end
	
	describe "#open_tickets" do

		it "should return missing_project_id when pivotal puller has not been set" do
			@mp = Todone::MessageProcessor.new
			@mp.open_tickets.should == 'missing_project_id'
		end

		it "should return pivotal_stories when stories are returned" do
			@mp = Todone::MessageProcessor.new({:project_id => 5})
			Todone::PivotalPuller.stubs(:get).returns({'stories'=> []})
			@mp.open_tickets.should == "pivotal_stories"
		end

		it "should return api_problem when an api error" do
			@mp = Todone::MessageProcessor.new({:project_id => 5})
			Todone::PivotalPuller.stubs(:get).raises(SocketError)
			@mp.open_tickets.should == "api_problem"
		end

		it "should return bad_state when passed a non-existant ticket state"

	end

	describe "dynamic print methods" do
		it "should exist if a method exists" do
			Todone::MessageProcessor.method_defined?('open_tickets').should == true
			@mp = Todone::MessageProcessor.new({:project_id => 5})
			@mp.print_open_tickets.should == nil 
		end
		it "should raise a method_missing error if the method does not exist" do
		
			Todone::MessageProcessor.method_defined?('get_me_a_coke').should_not == true
			@mp = Todone::MessageProcessor.new({:project_id => 5})
	    lambda {@mp.print_get_me_a_coke}.should raise_error NoMethodError
		end
	end
end
