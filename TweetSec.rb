# load list of words
require './words'

class TweetSec 

    attr_accessor :original_tweet, :modified_tweet, :word_list

    # capture tweet sent to account
    def initialize(tweet)
        @original_tweet = tweet
    end

    #find words in tweet
    def find_words 
        @original_tweet.scan(/[A-Za-z]{2,}/) do |word|

            if (validate_word(word)) 
                puts word
            end
        end
    end

    #check if the word is valid word
    def validate_word(word)
        $word_list[word] ? true: false

    end

 
    #replace words with one letter

    # evaluate password strength
        
        # find number of character types 
            # letters
            # digits
            # whitespace (spaces, tabs, newline)
            # other 

    #calculate score
        # tweet length * number of types

    # show response
        # strong: score >= 50
            # congratulatory tweet
        # weak: score < 50, score > 10
            # modify original tweet so it is strong. 
            # modified tweet shouldn't be longer than orginal
            # unless it must be lengthened to increase score
        # unacceptable: score >= 10
            # ask user to use better password

    # post a reply tweet

end

my_tweet = TweetSec.new(ARGV[0])

#puts my_tweet.original_tweet


my_tweet.find_words