# load list of words
require './words'

class TweetSec 

    attr_accessor :original_tweet, :modified_tweet

    # capture tweet sent to account
    def initialize(tweet)
        @original_tweet = tweet
        @modified_tweet = @original_tweet
    end

    #find words in tweet
    def find_words 
        # find letter combos greater than two letters
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
        # replace word if word is the tweet
        @modified_tweet = @modified_tweet.gsub(/\b#{word}\b/, 'a')

        puts @modified_tweet
    end 

    #calculate score
    def calculate_score
        @counts = { :letter_count => 0,
            :digit_count => 0,
            :whitespace_count => 0,
            :other_count => 0 }

        @score = 0

        # iterate through each character, and count each type
        @modified_tweet.each_byte do |c|
            #letters (upper and lower)
            if (c >=65 and c <= 90) or (c >=97 and c <= 122)
                @counts[:letter_count] += 1
            #numbers (0 to 9)
            elsif c >=48 and c <= 57
                @counts[:digit_count] += 1
            # whitespace (tab, newline, space)
            elsif  c == 9 or c ==10 or c == 32
                @counts[:whitespace_count] += 1
            # other 
            else
                @counts[:other_count] += 1
            end
        end
        puts @counts

        #find types whose counts > 0
        type_exists = @counts.select { |type|  @counts[type] > 0}
        puts type_exists.length

        @score =  type_exists.length * @modified_tweet.length
        puts @score

    end

    # show response
    def show_response
        # strong password : congrats
        if @score >= 50
            puts 'Congrats. Tweet is strong'
        # weak password : modify
        elsif  @score > 10
            puts 'weak'
            # modify original tweet so it is strong. 
            # modified tweet shouldn't be longer than orginal
            # unless it must be lengthened to increase score

        # unacceptable : reject
        else
            puts 'Enter stronger password'
        end
    end

    # strengthen a weak tweet
    # 13 * 4 = 52; 13 and 4 types is shortest allowable tweet
    def strengthen_weak_password
    end

    # change character to another type
    def modify_char(character) 
    end

end

my_tweet = TweetSec.new(ARGV[0])

#puts my_tweet.original_tweet


my_tweet.find_words
my_tweet.calculate_score
my_tweet.show_response
