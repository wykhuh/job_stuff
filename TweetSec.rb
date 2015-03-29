class TweetSec 
    attr_accessor :original_tweet, :modified_tweet

    def initialize(tweet)
        @original_tweet = tweet
        puts @original_tweet

    end

    # capture tweet sent to account

    # evaluate password strength
        # replace words with one letter

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

test = TweetSec.new(ARGV[0])