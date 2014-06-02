### http://sheltered-badlands-4782.herokuapp.com/

require 'sinatra'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

enable :sessions
helpers Sinatra::RedirectWithFlash

SITE_TITLE = "Secret Number"
SITE_DESCRIPTION = "Sinatra's favorite game"


def secret_number
    number = (1..10).to_a
    number = number.sample
end


get '/' do
  erb :game_start
end

post '/' do
  @player = params[:name]
  @@wins = 0
  @@losses = 0
  if @player.empty?
    #redirect '/', :danger => 'My mom said not to play with strangers.  Please enter your name.'
    redirect '/', :flash => {:danger => 'My mom said not to play with strangers.  Please enter your name.'} 
  end
  erb :instructions
end

get '/game' do
  @@secret_number = secret_number
  @@guesses = 3
  @@won = false
  erb :game
end

post '/game' do
  @@guesses -= 1
  @guess = params[:guess].to_i
  check = (1..10).to_a

  if !check.include?(@guess)
    @@guesses += 1
    flash.now[:danger] = 'Please pick a number between 1 and 10. You may keep your guess. (Your welcome)'
  else
    if @guess == @@secret_number
      flash.now[:success] = "Winner! Winner! Congrats you guessed the Secret Number.  Well played!"
      @@wins += 1
      @@guesses = 0
    elsif @guess < @@secret_number && @@guesses > 0
      flash.now[:warning] = 'Nope, that\'s not the Secret Number. Guess higher!'
    elsif @guess > @@secret_number && @@guesses > 0
      flash.now[:info] = 'Sorry, you guessed wrong. Guess lower!'
    else
      flash.now[:danger] = "You are out of guesses.  You lose.  The Secret Number was #{@@secret_number}."
      @@losses += 1
    end
  end

  erb :game
end