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
	  %x(mkdir #{CONFIG_DIR}) unless File.exists? CONFIG_DIR	
		File.open(ABS_CONFIG_FILE, 'w') {|f| f.write(dummy_config.to_yaml) }	
	end

	def ensure_no_pre_commit_hook!
		%x(ls)
	end
end
include FSHelp

class Class
  def publicize_methods
    saved_private_instance_methods = self.private_instance_methods
    self.class_eval { public *saved_private_instance_methods }
    yield
    self.class_eval { private *saved_private_instance_methods }
  end
end

