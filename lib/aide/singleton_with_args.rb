# frozen_string_literal: true

module Aide
  #
  # Ruby's standard library comes with the `Singleton` module which, quite
  # surprisingly, implements the singleton design pattern.
  #
  # In short: only one instance of a class is allowed in the program
  #
  # I mean, yeah you could mimic what Ruby does in its library in order to
  # achieve this, but why do that when you can define and use `Module.new`
  # in order to create a builder in order to create a class that you can
  # then use as an instantiating Singleton for all of your, for example,
  # different environments and have it look pretty...
  #
  # And yeah, you could do this by setting data on a class's singleton,
  # maybe with class level methods and variables and cool stuff like that...
  #
  # And maybe Config.leg_count is easier to use than
  # Config.instance.leg_count even though everyone knows more dot methods
  # are better...
  #
  # OR you could use `SingletonWithArgs`, which (it goes with saying) is not
  # the obvious nor (again) probably best choice.
  #
  # @example
  #   class CoolConfig
  #     include Aide::SingletonWithArgs(:first, :second)
  #   end
  #
  #   CoolConfig.new('is the worst', 'is the best')
  #   CoolConfig.instance == CoolConfig.instance # => true
  #   CoolConfig.instance.first                  # => 'is the worst'
  #   CoolConfig.instance.second                 # => 'is the best'
  #
  #
  # TODO: allow kwargs? allow defaults?
  def self.SingletonWithArgs(*args)
    SingletonWithArgs::Builder.new(*args)
  end

  module SingletonWithArgs
    #
    # Bob the Builder (don't make fun of him; he was named before Dora came
    # around) does all the heavy lifting here, SingletonWithArgs is just a
    # no-good (except looking) frontman 👌
    #
    class Builder < Module
      attr_reader :singleton_args
      private     :singleton_args

      def initialize(*inits)
        @singleton_args = inits
      end

      class NaughtyInitializer < Module
        attr_reader :singleton_args
        private     :singleton_args

        def initialize *init
          @singleton_args = init
        end

        def inspect
          "#<#{self.class.name} singleton_args: #{singleton_args}>"
        end
      end
      private_constant :NaughtyInitializer

      def included(klass)
        # first, include this naughty little class-wannabe
        klass.include NaughtyInitializer

        # this bad boy can fit so many singletons in it
        klass.include Singleton

        # now we wanna define ::new, which Singleton killed--down with the
        # standard library's oppressive tyranny!
        #
        # "instance" in this case refers to klass level, or (in other,
        # completely necessary words) klass's singleton class--which is the
        # klass in which we have included Ruby's Singleton module to make
        # klass follow the singleton pattern, and don't forget to keep in
        # mind that there is a singleton class on every class defined
        # because every class defined in Ruby is a class of class Class
        arg_list         = singleton_args.join(', ')
        attr_reader_list = klass
        klass.instance_eval <<~RUBY
        RUBY
        private
        def new #{arg_list}
          super 'args here'
        end
        private_class_method

        # how do we allow new to only happen once? or do we say ::init?
        # well... either way we need to allow it to only happen once
        # ::init may make more sense
        # ::set
        # ::est (establish)
        # ::set_up
        # ::birth
        # ::childbirth
        # ::genesis
        # ::spawn
        # ::visit_from_stork
        # ::uniq
        # ::uniquify_me
      end
    end
  end
end
