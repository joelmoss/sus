# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2021-2022, by Samuel Williams.

require 'io/console'
require 'stringio'

module Sus
	# Styled output output.
	module Output
		class Null
			def initialize
			end
			
			def buffered
				Buffered.new(nil)
			end
			
			attr :options
			
			def append(buffer)
			end

			def indent
			end
			
			def outdent
			end

			def indented
				yield
			end
			
			def write(*arguments)
				# Do nothing.
			end
			
			def puts(*arguments)
				# Do nothing.
			end
		end
	end
end
