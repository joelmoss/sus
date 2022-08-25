# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2021-2022, by Samuel Williams.

module Sus
	class Be
		def initialize(*arguments)
			@arguments = arguments
		end
		
		def print(output)
			operation, *arguments = *@arguments
			
			output.write("be ", :be, operation.to_s, :reset, " ", :variable, arguments.map(&:inspect).join, :reset)
		end
		
		def call(assertions, subject)
			assertions.assert(subject.public_send(*@arguments), self)
		end
		
		class << self
			def == value
				Be.new(:==, value)
			end
			
			def != value
				Be.new(:!=, value)
			end
			
			def > value
				Be.new(:>, value)
			end
			
			def >= value
				Be.new(:>=, value)
			end
			
			def < value
				Be.new(:<, value)
			end
			
			def <= value
				Be.new(:<=, value)
			end
			
			def =~ value
				Be.new(:=~, value)
			end
			
			def === value
				Be.new(:===, value)
			end
		end
	end
	
	class Base
		def be(*arguments)
			if arguments.any?
				Be.new(*arguments)
			else
				Be
			end
		end
		
		def be_a(klass)
			Be.new(:is_a?, klass)
		end
		
		def be_nil
			Be.new(:nil?)
		end
	end
end
