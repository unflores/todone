require 'rubygems'
require 'bundler'
require 'yaml'
require 'mocha'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

RSpec.configure do |config|
	config.mock_with :mocha
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'todone'
module FSHelp
	TMP_DIR = '/tmp'
  CONFIG_DIR = File.join(TMP_DIR, '.todone_config')
  ABS_CONFIG_FILE = File.join(CONFIG_DIR, Todone::Consts::CONFIG_FILE)
	
	def clean_test_config!
    %x(rm -rf #{CONFIG_DIR}) if File.exists? CONFIG_DIR
  end
	
	def dummy_config
		{:owner => 'name',:api_key => 'alkjlkjlkjfd512452354'}
	end	
	
	def ensure_fresh_config!
	  clean_test_config!
	  %x(mkdir -p #{CONFIG_DIR}) unless File.exists? CONFIG_DIR	
		
		File.open(ABS_CONFIG_FILE, 'w') {|f| f.write(dummy_config.to_yaml) }	
	end

end
include FSHelp

module PivotStories

	accepted = {
		"id"=>10622339, 
		"project_id"=>232039, 
		"story_type"=>"feature", 
		"url"=>"http://www.pivotaltracker.com/story/show/10622339", 
		"estimate"=>1, 
		"current_state"=>"accepted", 
		"description"=>"specifically the .git hooks.  I'm leaving off the config settings for now", 
		"name"=>"remove the file manipulation in the tests", 
		"requested_by"=>"Austin Flores", 
		"owned_by"=>"Austin Flores", 
		"created_at"=>"2011-03-02 06:38:25 UTC", 
		"updated_at"=>"2011-03-14 01:43:01 UTC", 
		"accepted_at"=>"2011-03-14 01:43:01 UTC"
	}
	
	unscheduled = {
		"id"=>9958691, 
		"project_id"=>232039, 
		"story_type"=>"feature", 
		"url"=>"http://www.pivotaltracker.com/story/show/9958691", 
		"estimate"=>1, 
		"current_state"=>"unscheduled", 
		"description"=>"returns the tickets/chores/bugs from pivotal tracker that have been completed/started for the current day.\n", 
		"name"=>"PivotalPuller grabs the day_stats from pivotal", 
		"requested_by"=>"Austin Flores", 
		"created_at"=>"2011-02-14 06:49:52 UTC", 
		"updated_at"=>"2011-02-14 06:50:17 UTC" 
	}
		
	unstarted = {
		"id"=>11211881, 
		"project_id"=>232039, 
		"story_type"=>"feature", 
		"url"=>"http://www.pivotaltracker.com/story/show/11211881", 
		"estimate"=>2, "current_state"=>"unstarted", 
		"description"=>"* Add a method that finds the other users on the project\n* gets all of the tickets that have been started/finished by them today\n*display that to the screen", 
		"name"=>"Add a daily_update method", 
		"requested_by"=>"Austin Flores", 
		"created_at"=>"2011-03-17 05:02:46 UTC", 
		"updated_at"=>"2011-03-17 05:02:51 UTC"
	}
	delivered = {
		"id"=>11255061, 
		"project_id"=>232039, 
		"story_type"=>"feature", 
		"url"=>"http://www.pivotaltracker.com/story/show/11255061", 
		"estimate"=>1, "current_state"=>"delivered", 
		"description"=>"if no project-id is given check git config", 
		"name"=>"Read project id from git config", 
		"requested_by"=>"Austin Flores", 
		"owned_by"=>"Austin Flores", 
		"created_at"=>"2011-03-18 01:08:32 UTC", 
		"updated_at"=>"2011-03-30 04:46:41 UTC"
	} 

end

include PivotStories

class Class
  def publicize_methods
    saved_private_instance_methods = self.private_instance_methods
    self.class_eval { public *saved_private_instance_methods }
    yield
    self.class_eval { private *saved_private_instance_methods }
  end
end
