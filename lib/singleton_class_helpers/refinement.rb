# frozen_string_literal: true

module SingletonClassHelpers
  ##
  # Refinement module that adds to Module the following methods:
  #
  # translated_name: translates singleton class pointers in the class name to a more human readable name
  #
  # singleton_of: returns the class from which the class is the singleton class.
  #
  module Refinement
    SINGLETON_MATCHER = /(#<Class:(0x\w+)>)/.freeze

    refine ::Module do
      # Returns the class name with singleton_classes names resolved.
      #
      # Example:
      #   using SingletonClassHelpers::Refinement
      #
      #   class TestClass; end
      #
      #   singleton_class = class << TestClass
      #     module SomeModule
      #       class << self
      #         self
      #       end
      #      end
      #   end
      #
      #   singleton_class.name #<Class:0x00007fee7fa7c4a0>::AnotherClass
      #   singleton_class.translated_name #<Class:#<Class:TestClass>::SomeModule>::AnotherClass
      def translated_name
        if singleton_class?
          translate(inspect)
        else
          inspect.split("::").collect do |part|
            translate(part)
          end.join("::")
        end
      end

      # Returns the class for which the module/class is the singleton class.
      #
      # It returns nil when the module/class is not a singleton class.
      def singleton_of
        return unless singleton_class?

        ObjectSpace.reachable_objects_from(self).find do |reachable_obj|
          reachable_obj.singleton_class == self
        end
      end

      private

      def translate(string) # :nodoc:
        string.gsub(SINGLETON_MATCHER) do |_match|
          obj = object_from_pointer(Regexp.last_match(2))
          obj_inspect = obj.inspect
          obj.singleton_class? ? translate(obj_inspect) : obj_inspect
        end
      end

      def object_from_pointer(pointer) # :nodoc:
        Fiddle::Pointer.new(Integer(pointer)).to_value
      end
    end
  end
end
