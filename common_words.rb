require 'wikipedia'
require 'optparse'

options = {
  times: 10
}

def skip?(categories, rejections)
  categories.product(rejections).detect do |cat, reject|
    cat.match(reject)
  end
end

OptionParser.new do |opts|
  opts.banner = <<-EOF
Build a list of common words, ignoring case, using Wikipedia as source.
Configure language and number of queries to your liking. Will print current
title as progress (to STDERR).

Suggested usage:
  ruby common_words.rb [-n 20] > outfile.txt

EOF

  opts.on('-n', '--times N', 'Amount of times') do |v|
    options[:times] = Integer(v)
  end

  opts.on('-x', '--reject CAT[,CAT[,CAT]...]', 'Reject these categories') do |v|
    options[:reject] = v.split(',')
  end
end.parse!

Wikipedia.Configure do
  domain 'sv.wikipedia.org'
  path   'w/api.php'
end

words = {}
options[:times].times do |i|
  article = Wikipedia.find_random
  redo if options[:reject] && skip?(article.categories, options[:reject])

  STDERR.puts "#{i}: #{article.title}"
  article.text.split.each do |x|
    y = x.downcase[/[[:alpha:]]*/]
    words[y] = words[y] ? words[y] + 1 : 0
  end
end

(words.sort_by { |_word, count| count }).reverse.each { |x| puts x.first }
