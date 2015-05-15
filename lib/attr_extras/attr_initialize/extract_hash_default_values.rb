module AttrExtras
  class AttrInitialize
    class ExtractHashDefaultValues
      def self.call(*args)
        new(*args).call
      end

      attr_reader :names_with_array_of_hash_arguments

      def initialize(names_with_array_of_hash_arguments)
        @names_with_array_of_hash_arguments = names_with_array_of_hash_arguments
      end

      def call
        plain_names = names_with_array_of_hash_arguments.take_while { |name_or_array| !name_or_array.is_a?(Array) }
        hash_names = (names_with_array_of_hash_arguments - plain_names).flatten

        hash_names_without_default_values = hash_names.take_while { |name| !name.is_a?(Hash) }
        default_values = (hash_names - hash_names_without_default_values).first

        hash_names_with_default_values = default_values ? default_values.keys : []
        hash_names = hash_names_without_default_values + hash_names_with_default_values

        attributes_names = plain_names
        attributes_names << hash_names if hash_names.any?

        [
          attributes_names,
          default_values
        ]
      end
    end
  end
end
