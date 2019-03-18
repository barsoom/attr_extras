module AttrExtras::Utils
  def self.flat_names(names)
    names.flatten.map { |x| x.is_a?(Hash) ? x.keys : x }
      .flatten.map { |x| x.to_s.sub(/!\z/, "") }
  end
end
