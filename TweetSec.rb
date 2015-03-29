# load list of words
require './words'

class TweetSec 

    attr_accessor :original_password, :modified_password

    def initialize(tweet)
        @original_password = tweet
        @modified_password = tweet
        @letters_arr = ('a'..'z').to_a + ('A'..'Z').to_a
        @digits_arr = (0..9).to_a
        @other_arr = ['#','%','^','*','<','>','/','-','+','~']
        @strong_password_min = 50
        @weak_password_min = 10
        # 50  / 4 types = 12.5; with 4 types, 13 chars is shortest allowable password
        @password_length_min = (@strong_password_min.to_f / 4).ceil
    end

    def check_submitted_password
        # find all letter combos
        combos = find_combos

        # if combo is a word, replace valid word with letter
        combos.each do |combo|
            if (validate_combo(combo)) 
                replace_word(combo)
            end
        end

        # calculate the score of the modified password
        score = calculate_score(@modified_password)

        # evaluate password and show response to user
        evaluate_password(score)

    end

    #find letter combos in password
    def find_combos 
        combos = []
        # find letter combos greater than two letters
        @original_password.scan(/[A-Za-z]{2,}/) do |combo|
            combos << combo
        end
        combos
    end

    #check if the combo is in the $word_list
    def validate_combo(combo)
        $word_list[combo] ? true: false
    end

 
    #replace words with one letter
    def replace_word(word)
        # pick random letter from word
        letter = word[rand(0..word.length-1)]

        # replace word if word is in the middle of the password
        @modified_password = @modified_password.gsub(/([^A-Za-z])#{word}([^A-Za-z])/, '\1'+letter+'\2')
        # replace word if word is at the start of password
        @modified_password = @modified_password.gsub(/\b#{word}([^A-Za-z])/, letter+'\1')
        # replace word if word is at end of password
        @modified_password = @modified_password.gsub(/([^A-Za-z])#{word}\b/, '\1'+letter)
        # replace word if word is the entire password
        @modified_password = @modified_password.gsub(/\b#{word}\b/, letter)

    end 

    #calculate score
    def calculate_score(password)
        @counts = { :letter => 0,
            :digit => 0,
            :whitespace => 0,
            :other => 0 }

        score = 0

        # iterate through each character, and count each type
        password.each_byte do |c|
            # change byte into characcter
            c = c.chr
            #letters 
            if /[A-Za-z]/.match(c)
                @counts[:letter] += 1
            #numbers 
            elsif /\d/.match(c)
                @counts[:digit] += 1
            # whitespace 
            elsif  /[\t\n ]/.match(c)
                @counts[:whitespace] += 1
            # other 
            else
                @counts[:other] += 1
            end
        end

        #find types whose counts > 0
        existing_types = @counts.select { |type|  @counts[type] > 0}

        score =  existing_types.length * password.length
    end

    # evaluate password and show response to user
    def evaluate_password(score)

        # strong password : congrats
        if score >= @strong_password_min
            puts 'Congrats. Password is strong'

        # weak password : modify password
        elsif  score > @weak_password_min
            strengthen_weak_password
            score = calculate_score(@modified_password)
            puts 'Password is weak. Here is a better password:', @modified_password

        # unacceptable : reject password
        else
            puts 'Enter stronger password.'
        end

        puts 'score: ' + score.to_s
    end

    # strengthen a weak password by adding types and/or characters
    def strengthen_weak_password

        # if password length >= minimum length, modify characters to eliminate missing types
        if @modified_password.length >= @password_length_min
            replace_characters

        # else lengthen password and modify characters
        else
            # add random character to beginning of password until password is minimum length
            while(@modified_password.length < @password_length_min)
                all_arr = @letters_arr + @digits_arr + @other_arr + [' ']
                # convert to string because there are numbers in all_arr
                random_character = all_arr[rand(0..all_arr.length-1)].to_s
                @modified_password =   random_character + @modified_password
            end
            # modify characters to eliminate missing types
            replace_characters
        end
    end

    # in order to maximize the score, we want the maximum number of types. 
    # we only modify characters whose type count > 1 so that we don't
    # eliminate an existing type.
    def get_modifiable_types
        @counts.select { |type|  @counts[type] > 1}
    end

    def get_missing_types
        @counts.select { |type|  @counts[type] == 0}
    end

    # replace characters in the password with characters from types that
    # the password does not have
    def replace_characters
        # each type has regex and one random character  
        types_data = { 
            :letter => {'regex' => '[A-Za-z]',
                'replace' => @letters_arr[rand(0..51)] }, 
            :digit => {'regex' => '\d',
                'replace' => @digits_arr[rand(0..9)].to_s },
            :whitespace => {'regex' => '[\t\n ]',
                'replace' => ' ' },
            :other => {'regex' => '[^A-Za-z0-9\t\n ]',
                'replace' => @other_arr[rand(0..9)] }
        }

        # get all missing types 
        missing_types = get_missing_types

        missing_types.each do |missing_type|
            # get first type that is modifiable
            first_modifiable_type = get_modifiable_types.keys[0]

            # search the password and replace a character from modifiable_types
            # with a character from missing_types
            regex = types_data[first_modifiable_type]['regex']
            replacement = types_data[missing_type[0]]['replace']

            @modified_password = @modified_password.sub(/#{regex}/, replacement )
        end

    end

end

my_password = TweetSec.new(ARGV[0])

my_password.check_submitted_password

