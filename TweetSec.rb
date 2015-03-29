# load list of words
require './words'

class TweetSec 

    attr_accessor :original_tweet, :modified_tweet, :word_list

    # capture tweet sent to account
    def initialize(tweet)
        @original_tweet = tweet
        @modified_tweet = @original_tweet
    end

    #find words in tweet
    def find_words 
        @original_tweet.scan(/[A-Za-z]{2,}/) do |word|
            if (validate_word(word)) 
                replace_word(word)
            end
        end
    end

    #check if the word is in the $word_list
    def validate_word(word)
        $word_list[word] ? true: false

    end

 
    #replace words with one letter
    def replace_word(word)
        # replace word if word is in the middle of the tweet
        @modified_tweet = @modified_tweet.gsub(/([^A-Za-z])#{word}([^A-Za-z])/, '\1a\2')
        # replace word if word is at the start of tweet
        @modified_tweet = @modified_tweet.gsub(/\b#{word}([^A-Za-z])/, 'a\1')
        # replace word if word is at end of tweet
        @modified_tweet = @modified_tweet.gsub(/([^A-Za-z])#{word}\b/, '\1a')

        puts @modified_tweet
    end 

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

    # strengthen a week tweet

end

my_tweet = TweetSec.new(ARGV[0])

#puts my_tweet.original_tweet


my_tweet.find_words