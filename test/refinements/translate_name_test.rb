# frozen_string_literal: true

require "test_helper"

class TranslateNameTest < Minitest::Test
  using SingletonClassHelpers::Refinement

  def setup
    define_class("TestClass")
    define_module("TestModule")
  end

  def teardown
    Object.send(:remove_const, "TestClass")
    Object.send(:remove_const, "TestModule")
  end

  def test_translated_name_on_a_class_returns_the_class_name
    assert_equal "TestClass", TestClass.translated_name
  end

  def test_translated_name_on_a_module_returns_the_module_name
    assert_equal "TestModule", TestModule.translated_name
  end

  # rubocop:disable Security/Eval
  def test_test_translated_name_on_a_class_with_namespace_returns_the_class_name
    source = <<~RUBY
      class ::TestClass
        module SomeModule
          class AnotherClass
          end
        end
      end
    RUBY
    eval(source)

    expected = "TestClass::SomeModule::AnotherClass"
    assert_equal expected, TestClass::SomeModule::AnotherClass.translated_name
  end
  # rubocop:enable Security/Eval

  # rubocop:disable Security/Eval
  def test_test_translated_name_on_a_module_with_namespace_returns_the_class_name
    source = <<~RUBY
      class ::TestClass
        module SomeModule
          class AnotherModule
          end
        end
      end
    RUBY
    eval(source)

    expected = "TestClass::SomeModule::AnotherModule"
    assert_equal expected, TestClass::SomeModule::AnotherModule.translated_name
  end
  # rubocop:enable Security/Eval

  def test_translated_name_on_the_singleton_class_of_class
    singleton_class = class << Class
                  self
                end

    assert_equal "#<Class:Class>", singleton_class.translated_name
  end

  def test_translated_name_on_the_singleton_class_of_module
    singleton_class = class << Module
                  self
                end

    assert_equal "#<Class:Module>", singleton_class.translated_name
  end

  def test_translated_name_on_the_singleton_class_of_object
    singleton_class = class << Object
                  self
                end

    assert_equal "#<Class:Object>", singleton_class.translated_name
  end

  def test_translated_name_on_the_singleton_class_of_basic_object
    singleton_class = class << BasicObject
                  self
                end

    assert_equal "#<Class:BasicObject>", singleton_class.translated_name
  end

  def test_translated_name_on_the_singleton_class_of_a_class
    assert_equal "#<Class:TestClass>", TestClass.singleton_class.translated_name
  end

  def test_translated_name_on_the_singleton_class_of_a_module
    assert_equal "#<Class:TestModule>", TestModule.singleton_class.translated_name
  end

  def test_translated_name_on_the_singleton_class_of_the_singleton_of_a_class
    singleton_klass = class << TestClass
                        class << self
                          self
                        end
                     end

    assert_equal "#<Class:#<Class:TestClass>>", singleton_klass.translated_name
  end

  def test_translated_name_on_a_class_inside_a_singleton_class
    klass = class << TestClass
              class AnotherClass
                self
              end
            end
    assert_equal "#<Class:TestClass>::AnotherClass", klass.translated_name
  end

  def test_translated_name_on_a_class_inside_a_module_singleton_class_inside_a_class_singleton_class
    klass = class << TestClass
              module SomeModule
                class << self
                  class AnotherClass
                    self
                  end
                end
              end
    end
    expected = "#<Class:#<Class:TestClass>::SomeModule>::AnotherClass"
    assert_equal expected, klass.translated_name
  end

  def test_translated_name_on_a_class_inside_a_module_singleton_class_inside_a_module_singleton_class
    klass = class << TestModule
              module SomeModule
                class << self
                  class AnotherClass
                    self
                  end
                end
              end
    end
    expected = "#<Class:#<Class:TestModule>::SomeModule>::AnotherClass"
    assert_equal expected, klass.translated_name
  end

  def test_translated_name_on_a_singleton_class_inside_a_module_singleton_class_inside_a_class_singleton_class
    klass = class << TestClass
              module SomeModule
                class << self
                  class AnotherClass
                    class << self
                      self
                    end
                  end
                end
              end
    end
    expected = "#<Class:#<Class:#<Class:TestClass>::SomeModule>::AnotherClass>"
    assert_equal expected, klass.translated_name
  end

  def test_translated_name_on_the_singleton_class_of_an_anonymous_class
    singleton_class = Class.new.singleton_class
    assert_equal singleton_class.inspect, singleton_class.translated_name
  end

  def test_translated_name_on_the_singleton_class_of_an_instance_of_a_class
    singleton_class = Object.new.singleton_class
    assert_equal singleton_class.inspect, singleton_class.translated_name
  end

  def test_translated_name_on_a_class_defined_in_the_singleton_class_of_an_instance_of_a_class
    obj = Object.new
    klass = class << obj
              class SomeClass
                self
              end
            end

    translated_name = klass.translated_name
    refute klass.inspect == translated_name
    assert_equal "#<Class:#{obj}>::SomeClass", translated_name
  end

  def test_translated_name_on_a_singleton_class_in_the_singleton_class_of_an_instance_of_a_class
    obj = Object.new
    singleton_class = class << obj
                   class SomeClass
                     class << self
                       self
                     end
                   end
            end
    translated_name = singleton_class.translated_name
    refute singleton_class.inspect == translated_name
    assert_equal "#<Class:#<Class:#{obj}>::SomeClass>", translated_name
  end
end
