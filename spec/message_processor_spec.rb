require 'helper'

describe Done::MessageProcessor do
	before(:each) { FSHelp::clean_test_config! }
	describe "self#needs_init?" do
		it " should return true there is no config.yml" do
			Done::MessageProcessor.needs_init?(FSHelp::CONFIG_DIR).should == true
		end
		it " should return false when there is a config.yml" do
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
	end
	
	describe "#add_project" do
		before(:each) do
			FSHelp::ensure_fresh_config! 
			@mp = Done::MessageProcessor.new(FSHelp::CONFIG_DIR)
		end
		
		it " should add a project to config if it is not present" do
			project = { :users => 'frank_drebbin', :id => '555555' }
			@mp.add_project(project).should == true
			config = File.open( FSHelp::ABS_CONFIG_FILE ) { |yf| YAML::load( yf ) }
			config.should == FSHelp::dummy_config.merge({:'555555'=> ["frank_drebbin"]})
		end
		
		it " should edit a project in config if project is present" do
			project = {:user => 'frank_drebbin', :project => 555555 }
			@mp.add_project project
			config = File.open( FSHelp::ABS_CONFIG_FILE ) { |yf| YAML::load( yf ) }
			config.should == FSHelp::dummy_config
		end
		
		it " should add a hook to .git/hooks/pre-commit if not present"
	end
end
