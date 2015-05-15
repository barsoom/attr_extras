module AttrExtras
  class AttrInitialize
    class Attributes
      def initialize(names_with_array_of_hash_arguments)
        @names_with_array_of_hash_arguments = names_with_array_of_hash_arguments
      end

      def plain
        @attributes_names ||= names_with_array_of_hash_arguments.take_while { |name_or_array| !name_or_array.is_a?(Array) }
      end

      def hash
        @hash_names ||= hash_names_without_default_values + default_values.keys
      end

      def default_values
        return @default_values if @default_values

        @default_values = (hash_names_with_default_values - hash_names_without_default_values).first
        @default_values ||= {}
      end

      private

      def hash_names_with_default_values
        (names_with_array_of_hash_arguments - plain).flatten
      end

      def hash_names_without_default_values
        hash_names_with_default_values.take_while { |name| !name.is_a?(Hash) }
      end

      attr_reader :names_with_array_of_hash_arguments
    end
  end
end
