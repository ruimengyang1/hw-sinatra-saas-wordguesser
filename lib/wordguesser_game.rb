class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  attr_accessor :word, :guesses, :wrong_guesses
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    raise ArgumentError if letter.nil? || letter == '' || letter !~ /\A[a-zA-Z]\z/
    letter = letter.downcase
    return false if @guesses.include?(letter) || @wrong_guesses.include?(letter)
    if @word.include?(letter)
      @guesses << letter
    else
      @wrong_guesses << letter
    end
    true
  end

  def word_with_guesses
    letters = []                

    @word.chars.each do |ch|    
      if @guesses.include?(ch)  
        letters << ch            
      else
        letters << '-'          
      end
    end

    letters.join                 
  end
  def check_win_or_lose
    status = :play
    win = true
    @word.chars.each do |letter|
      if !@guesses.include?(letter)
        win = false
      end
    end

    if win == true
      status = :win
    end
    # if>7
    if @wrong_guesses.length >= 7
      status = :lose
    end
    # if not
    return status
  end


  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://esaas-randomword-27a759b6224d.herokuapp.com/RandomWord') 
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http| 
      return http.post(uri, "").body
    end
  end
end
