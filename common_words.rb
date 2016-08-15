# Build a list of common words, ignoring case, using Wikipedia as source.
# Configure language and number of queries to your liking. Will print current
# title as progress (to STDERR).
#
# Suggested usage:
#   ruby common_words.rb > outfile.txt

require 'wikipedia'

Wikipedia.Configure do
  domain 'sv.wikipedia.org'
  path   'w/api.php'
end

words = {}

100.times do |i|
  article = Wikipedia.find_random
  STDERR.puts "#{i}: #{article.title}"
  article.text.split.each do |x|
    y = x.downcase[/[[:alpha:]]*/]
    words[y] = words[y] ? words[y] + 1 : 0
  end
end

(words.sort_by { |_word, count| count }).reverse.each { |x| puts x.first }

