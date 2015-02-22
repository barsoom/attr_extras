module AttrExtras::Utils
  def self.flat_names(names)
    names.flat_map { |x|
      case x
      when Array
        flat_names(x)
      when Hash
        flat_names(x.keys)
      else
        x.to_s.sub(/!\z/, "")
      end
    }
  end
end
