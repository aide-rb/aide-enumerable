# frozen_string_literal: true

require 'enumerable/version'

module Aide
  # If you're really feeling the urge to do some recursive enumeration (except
  # really for comparative methods--those will break joyously), then this
  # extension is for you.
  #
  # `require 'aide-enumerable'` to add ::Enumerable#recursive
  # along with the Recursor class
  module Enumerable
    module ::Enumerable
      def recursive
        Aide::Enumerable::Recursor.new self
      end
    end

    class Recursor
      class NotEnumerable < StandardError
        def initialize(obj); super obj.inspect; end
      end

      include Enumerable

      attr_reader :enum
      private :enum
      def initialize enum
        @enum = enum
      end

      def each &block
        return enum_for(:each) unless block_given?

        enum.each do |member|
          case member
          when self.class, Enumerable then member.each &block
          else yield member
          end
        end
      end
    end # Recursor
  end # Enumerable
end # Aide
