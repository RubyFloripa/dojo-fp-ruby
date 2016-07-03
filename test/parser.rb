require 'benchmark'

content = IO.read('sample_weed.txt')
title, _, _, content = content.split("\n")

class Proc
  def self.compose(f, g)
    lambda { |*args| f[g[*args]] }
  end

  def *(g)
    Proc.compose(self, g)
  end
end

sanitize = lambda { |string|
  string.split("").map do |char|
    case char
    when "á", "à", "ã", "â" then "a"
    when "é", "ê"           then "e"
    when "í", "ì"           then "i"
    when "ó", "ô", "õ"      then "o"
    when "ú" then "u"
    when " " then " "
    when /\W/ then " "
    else char
    end
  end.join ""
}

downcase = lambda { |text|
  text.downcase
}

upper = lambda { |text|
  text.upcase
}

full_content = title + content

pipeline = sanitize * downcase * upper

normalized_call = nil
normalized_lamda = nil

puts Benchmark.measure {
  100.times {
    normalized_call = sanitize[downcase[upper[full_content]]]
  }
}

puts Benchmark.measure {
  100.times {
    normalized_lamda = pipeline[full_content]
  }
}

puts normalized_call

puts '----'

puts normalized_lamda

puts '----'

puts normalized_call == normalized_lamda
