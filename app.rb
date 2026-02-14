require 'sinatra/base'
require 'sinatra/flash'
require_relative 'lib/wordguesser_game'

class WordGuesserApp < Sinatra::Base
  enable :sessions
  register Sinatra::Flash
  set :session_secret, ENV.fetch('SESSION_SECRET', 'dev_secret_change_me')
  set :host_authorization, { permitted_hosts: [] }  

  before do
    @game = session[:game] || WordGuesserGame.new('')
  end

  after do
    session[:game] = @game
  end

  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end

  get '/new' do
    erb :new
  end

  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || WordGuesserGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = WordGuesserGame.new(word)
    redirect '/show'
  end

  # Use existing methods in WordGuesserGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."

  post '/guess' do
    guess = params[:guess].to_s[0]

    begin
      valid = @game.guess(guess)

      if valid == false
        flash[:message] = "You have already used that letter."
      end

    rescue ArgumentError
      flash[:message] = "Invalid guess."
    end

    redirect '/show'
  end

  post '/new' do
  word = params[:word] || WordGuesserGame.get_random_word
  @game = WordGuesserGame.new(word)
  redirect '/show'
end

  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in WordGuesserGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
    status = @game.check_win_or_lose

    if status == :win
      redirect '/win'
    elsif status == :lose
      redirect '/lose'
    else
      @wrong_guesses = @game.wrong_guesses
      @word_with_guesses = @game.word_with_guesses
      erb :show
    end
  end

  get '/win' do
    redirect '/show' unless @game.check_win_or_lose == :win
    @wrong_guesses = @game.wrong_guesses
    @word_with_guesses = @game.word_with_guesses
    erb :win
  end

  get '/lose' do
    redirect '/show' unless @game.check_win_or_lose == :lose
    @wrong_guesses = @game.wrong_guesses
    @word_with_guesses = @game.word_with_guesses
    erb :lose
  end
end
