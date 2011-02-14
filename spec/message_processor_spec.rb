require 'helper'

describe Done::MessageProcessor do
	before(:each) { FSHelp::clean_test_config! }
	describe "self#needs_init?" do
		it "should return true there is no config.yml" do
			Done::MessageProcessor.needs_init?(FSHelp::CONFIG_DIR).should == true
		end
	
		it "should return false when there is a config.yml" do
			ensure_fresh_config!
			Done::MessageProcessor.needs_init?(FSHelp::CONFIG_DIR).should == false
		end
	end

	describe "self#init" do
		it "should set owner and api_key when given those options" do
			options = { :dir => FSHelp::CONFIG_DIR }.merge(FSHelp::dummy_config)
			Done::MessageProcessor.init options
			config = File.open( FSHelp::ABS_CONFIG_FILE ) { |yf| YAML::load( yf ) }
			config.should == FSHelp::dummy_config
		end
		
		it "should return nil if :api_key or :owner arent passed in" do
			options = { :dir => FSHelp::CONFIG_DIR }
			Done::MessageProcessor.init(options).should == nil
		end
	end
	
	describe "#add_project" do
		before(:each) do
			FSHelp::ensure_fresh_config! 
			@mp = Done::MessageProcessor.new(FSHelp::CONFIG_DIR)
			@project = { :users => 'frank_drebbin', :id => '555555' }
			FSHelp::ensure_no_pre_commit_hook!
		end
		
		it "should edit a project in config if project is present" do
			@mp.add_project @project
			config = File.open( FSHelp::ABS_CONFIG_FILE ) { |yf| YAML::load( yf ) }
			config.should == FSHelp::dummy_config.merge({:'555555'=> ["frank_drebbin"]})
			@mp.add_project @project
			config = File.open( FSHelp::ABS_CONFIG_FILE ) { |yf| YAML::load( yf ) }
			config.should == FSHelp::dummy_config.merge({:'555555'=> ["frank_drebbin"]})
		end
		
		it "should add a hook to .git/hooks/pre-commit if not present"
		it "should not add a hook if .git/hooks/pre-commit is not present"
		it "should not add a hook if .git/hooks/pre-commit cannot be found"
	end
end
