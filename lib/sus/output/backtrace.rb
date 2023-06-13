# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2022, by Samuel Williams.

module Sus
  module Output
    # Print out a backtrace relevant to the given test identity if provided.
    class Backtrace
      def self.first(identity = nil)
        # This implementation could be a little more efficient.
        new(caller_locations(1), identity&.path, 1)
      end

      def self.for(exception, _identity = nil, verbose = false)
        # I've disabled the root filter here, because partial backtraces are not very useful.
        # We might want to do something to improve presentation of the backtrace based on the root instead.
        new(exception.backtrace_locations, verbose ? nil : Pathname.pwd.to_s)
      end

      def initialize(stack, root = nil, limit = nil)
        @stack = stack
        @root = root
        @limit = limit
      end

      def filter(_root = @root)
        stack = if @root
                  @stack.select do |frame|
                    !frame.path.start_with?('/') || frame.path.start_with?(@root)
                  end
                else
                  @stack
                end

        stack = stack.take(@limit) if @limit

        stack
      end

      def print(output)
        if @limit == 1
          filter.each do |frame|
            path = @root ? "./#{frame.path.delete_prefix("#{@root}/")}" : frame.path
            output.write ' ', :path, path, :line, ':', frame.lineno
          end
        else
          output.indented do
            filter.each do |frame|
              path = @root ? "./#{frame.path.delete_prefix("#{@root}/")}" : frame.path
              output.puts :indent, :path, path, :line, ':', frame.lineno, :reset, ' ', frame.label
            end
          end
        end
      end
    end
  end
end
