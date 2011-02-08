$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'done')

%w(config consts).each{|requirement| require requirement}

module Done
	class MessageProcessor
		attr :config

		def initialize
			
		end
	end
end
