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
        letter = word[0]

        # replace word if word is in the middle of the tweet
        @modified_tweet = @modified_tweet.gsub(/([^A-Za-z])#{word}([^A-Za-z])/, '\1'+letter+'\2')
        # replace word if word is at the start of tweet
        @modified_tweet = @modified_tweet.gsub(/\b#{word}([^A-Za-z])/, letter+'\1')
        # replace word if word is at end of tweet
        @modified_tweet = @modified_tweet.gsub(/([^A-Za-z])#{word}\b/, '\1'+letter)
        # replace word if word is the entire tweet
        @modified_tweet = @modified_tweet.gsub(/\b#{word}\b/, letter)

        puts @modified_tweet
    end 

    #calculate score
    def calculate_score
        @counts = { :letter => 0,
            :digit => 0,
            :whitespace => 0,
            :other => 0 }

        @score = 0

        # iterate through each character, and count each type
        @modified_tweet.each_byte do |c|
            #letters (upper or lower)
            if (c >=65 and c <= 90) or (c >=97 and c <= 122)
                @counts[:letter] += 1
            #numbers (0 to 9)
            elsif c >=48 and c <= 57
                @counts[:digit] += 1
            # whitespace (tab, newline, space)
            elsif  c == 9 or c ==10 or c == 32
                @counts[:whitespace] += 1
            # other 
            else
                @counts[:other] += 1
            end
        end

        #find types whose counts > 0
        existing_types = @counts.select { |type|  @counts[type] > 0}

        @score =  existing_types.length * @modified_tweet.length
        puts @score
    end

    # show response
    def show_response
        # strong password : congrats
        if @score >= 50
            puts 'Congrats. Password is strong'
        # weak password : modify tweet
        elsif  @score > 10
            strengthen_weak_password
            puts 'Password is weak. Here is a better password:', @modified_tweet

        # unacceptable : reject tweet
        else
            puts 'Enter stronger password.'
        end
        puts 'score: ' + @score.to_s
    end

    # strengthen a weak tweet
    # 13 characters * 4 types = 52; 13 and 4 types is shortest allowable tweet
    def strengthen_weak_password

        # if tweet length >= 13, modify characters to eliminate missing types
        if @modified_tweet.length >= 13
            replace_characters

        # else if length < 13, lengthen tweet and modify characters
        else
            # add characters to tweet until tweet is 13 characters
            while(@modified_tweet.length < 13)
                @modified_tweet = ('a'..'z').to_a[rand(0..25)] + @modified_tweet
            end
            # modify characters to eliminate missing types
            replace_characters
        end
    end

    # in order to maximize the score, we want the maximum number of types. 
    # we only modify characters whose type count > 1 so that we don't
    # eliminate an existing type.
    def get_modifiable_types
        modifiable_types = @counts.select { |type|  @counts[type] > 1}
        puts modifiable_types
        modifiable_types
    end

    def get_missing_types
        missing_types  = @counts.select { |type|  @counts[type] == 0}
        puts missing_types
        missing_types
    end

    # replace characters in the tweet
    def replace_characters
        # for each type, list the regex and one random character  
        types_data = { 
            :letter => {'regex' => '[A-Za-z]',
                'replace' => ('a'..'z').to_a[rand(0..25)] }, 
            :digit => {'regex' => '[0-9]',
                'replace' => (0..9).to_a[rand(0..9)].to_s },
            :whitespace => {'regex' => '[\t\n ]',
                'replace' => ' ' },
            :other => {'regex' => '[^A-Za-z0-9\t\n ]',
                'replace' => ['#','%','^','*','<','>','/','-','+','~'][rand(0..9)] }
        }

        # get all types whose count > 0, thereby are missing
        missing_types = get_missing_types

        missing_types.each do |missing_type|
            # get first type whose count > 1, thereby is modifiable
            first_modifiable_type = get_modifiable_types.keys[0]

            # search the tweet and replace a character from modifiable_types
            # with a character from missing_types
            regex = types_data[first_modifiable_type]['regex']
            replacement = types_data[missing_type[0]]['replace']

            @modified_tweet = @modified_tweet.sub(/#{regex}/, replacement )
            puts @modified_tweet
            calculate_score

        end

    end

end

my_tweet = TweetSec.new(ARGV[0])

#puts my_tweet.original_tweet


my_tweet.find_words
my_tweet.calculate_score
my_tweet.show_response

