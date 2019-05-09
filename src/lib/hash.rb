class Hash

  # Usage { :a => 1 }.with_stringified_keys -> { "a" => 1 }
  def with_stringified_keys
    self.each { |k,v|
      self.delete k
      self[k.to_s] = v
    }
  end

  # Usage { :a => 1, :b => 2, :c => 3}.except(:a) -> { :b => 2, :c => 3}
  def except(*keys)
    self.reject { |k,v|
      keys.include? k.to_sym
    }
  end

  # Usage { :a => 1, :b => 2, :c => 3}.only(:a) -> {:a => 1}
  def only(*keys)
    self.dup.reject { |k,v|
      !keys.include? k.to_sym
    }
  end

  # Usage is the same as the only method, but returns a value for single key instead of whole hash
  def only_value(key)
    only(key)[key]
  end
end
