# @see http://mjijackson.com/2010/02/flexible-ruby-config-objects
# @author Michael Jackson
# 
# config = Config.new
# config.database = 'database_name'
# config.username = 'user'
# config.db_hosts = {
#   'sj'  => 'sanjose.example.com',
#   'ny'  => 'newyork.example.com'
# }
# 
# config.username         # "user"
# config.db_hosts.ny      # "newyork.example.com"
module Done
	class Config

		class << self
      # @see Done::Consts:CONFIG_FILE
      # @param [String] dir The directory to look in for the file specified by {Done::Consts::CONFIG_FILE}
      # @return [Done::Config] The populated {Config} instance
      def load_config dir
        require 'yaml'
        data = YAML.load(File.open(File.join(dir, Done::Consts::CONFIG_FILE)).read)
        Done::Config.new data
      end
  	end


		def initialize(data={})
			@data = {}
			update!(data)
		end

		def update!(data)
			data.each do |key, value|
				self[key] = value
			end
		end

		def [](key)
			@data[key.to_sym]
		end

		def []=(key, value)
			if value.class == Hash
				@data[key.to_sym] = Config.new(value)
			else
				@data[key.to_sym] = value
			end
		end
		def to_hash; @data end

		def method_missing(sym, *args)
			if sym.to_s =~ /(.+)=$/
				self[$1] = args.first
			else
				self[sym]
			end
		end
	end
end
