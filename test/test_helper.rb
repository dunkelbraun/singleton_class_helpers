# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  add_filter %r{^/test/}
  enable_coverage :branch
end

require "byebug"
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "singleton_class_helpers"

require "minitest/autorun"

class MiniTest::Test
  def define_class(class_name)
    Object.class_eval <<~RUBY, __FILE__, __LINE__ + 1
      class #{class_name}; end
    RUBY
  end

  def define_module(module_name)
    Object.class_eval <<~RUBY, __FILE__, __LINE__ + 1
      module #{module_name}; end
    RUBY
  end
end
