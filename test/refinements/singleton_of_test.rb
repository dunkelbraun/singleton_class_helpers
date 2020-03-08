# frozen_string_literal: true

require "test_helper"

class SingletonOfTest < Minitest::Test
  using SingletonClassHelpers::Refinement

  def setup
    define_class("TestClass")
    define_module("TestModule")
  end

  def teardown
    Object.send(:remove_const, "TestClass")
    Object.send(:remove_const, "TestModule")
  end

  def test_singleton_of_is_nil_on_a_class
    assert_nil TestClass.singleton_of
  end

  def test_singleton_of_is_nil_on_a_module
    assert_nil TestModule.singleton_of
  end

  def test_singleton_of_is_the_object_on_a_singleton_of_an_object
    obj = TestClass.new
    metaclass = class << obj
                  self
                end

    assert_equal obj, metaclass.singleton_of
  end

  def test_singleton_of_is_the_class_on_a_singleton_of_a_class
    metaclass =
      class << TestClass
        self
      end
    assert_equal TestClass, metaclass.singleton_of
  end

  def test_singleton_of_is_the_module_on_a_singleton_of_a_module
    metaclass =
      class << TestModule
        self
      end
    assert_equal TestModule, metaclass.singleton_of
  end
end
