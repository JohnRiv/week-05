# 
# Here is where you will write the class Quotes
# 
# For more information about classes I encourage you to review the following:
# 
# @see http://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Classes
# @see Programming Ruby, Chapter 3
# 
# 
# For this exercise see if you can employ the following techniques:
# 
# Use class convenience methods: attr_reader; attr_writer; and attr_accessor.
# 
# Try using alias_method to reduce redundancy.
# 
# @see http://rubydoc.info/stdlib/core/1.9.2/Module#alias_method-instance_method
# 
class Quotes
  attr_reader :file
  # this gives us:
  # 
  # def file
  #  @file
  # end
  #
  # attr_accessor = read & write (getter & setter)
  # attr_reader = read only (getter)
  # attr_writer = writer only (setter)

  # class variables start with "@@"
  @@missing_quote = "Could not find a quote at this time"

  def initialize(params)
    @file = params[:file] # instance variables = start with an "@"

  end

  def quotes
  # readlines will return an array of lines but includes the newline character "\n"
  # here we strip that off of all the quotes.
    @quotes ||= if File.exists? @file
      File.readlines(@file).map {|quote| quote.strip }
    else
      []
    end
  end
  
  alias :all :quotes

  def find(line)
    # taken from week 4 & modified
    if quotes.empty?
      @@missing_quote
    else
      quotes[line] || quotes[0]
    end
  end

  alias :[] :find

  def search(params = {})
    # taken from week 4 & modified
    found_quotes = quotes

    params.each do |key, value|
      # the respond_to? code handles our newly added "gibberish" test
      found_quotes = found_quotes.find_all do |quote|
        quote.send("#{key}?", value) if quote.respond_to?("#{key}?")
      end unless value.nil?
    end

    found_quotes
  end

  # Class methods (as opposed to an instance methods) are executed on the Class itself
  def self.load(file)
    # self & Quotes are the same thing, since we're in the Quotes class
    self.new(:file => file)
  end

  def self.missing_quote=(missing_quote)
    @@missing_quote = missing_quote
  end
  # could also write the 2 above with a closure if you don't want to keep writing "self."
  #class << self
  # def load(file)
  #   # self & Quotes are the same thing, since we're in the Quotes class
  #   self.new(:file => file)
  # end
  #
  # def missing_quote=(missing_quote)
  #    @@missing_quote = missing_quote
  #  end
  #end

end
