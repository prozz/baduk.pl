class String

  # performs strip on the string and replaces all \n and \r with empty strings
  def tidy_eols
    self.strip.gsub(/\n/,'').gsub(/\r/,'')
  end
  alias :with_eols_removed :tidy_eols

  def self.random(max_length = 8, char_re = /[\w\d]/)
    raise ArgumentError.new('char_re must be a regular expression!') unless char_re.is_a?(Regexp)
    string = ""
    while string.length < max_length
        ch = rand(255).chr
        string << ch if ch =~ char_re
    end
    return string
  end
end
