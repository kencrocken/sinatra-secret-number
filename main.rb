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

def check_name(player_name)
  if player_name.empty?
    redirect '/', :flash => {:danger => 'My mom said not to play with strangers.  Please enter your name.'} 
  end
end

def check_number(guess)
  check = (1..10).to_a
  if !check.include?(guess)
    @@guesses += 1
    flash.now[:danger] = 'Please pick a number between 1 and 10. You may keep your guess. (Your welcome)'
  else
    if guess == @@secret_number
      flash.now[:success] = "<i class='fa fa-thumbs-o-up'></i> Winner! Winner! Congrats #{@@player}! You guessed the Secret Number, #{@@secret_number}.  Well played!"
      @@wins += 1
      @@guesses = 0
    elsif guess < @@secret_number && @@guesses > 0
      flash.now[:warning] = "<i class='fa fa-frown-o'></i> Nope. #{@guess} is not the Secret Number, #{@@player}. Guess higher!"
    elsif guess > @@secret_number && @@guesses > 0  
      flash.now[:info] = "<i class='fa fa-frown-o'></i> Sorry #{@@player}, #{@guess} is wrong. Guess lower!"
    else
      flash.now[:danger] = "<i class='fa fa-thumbs-o-down'></i> You are out of guesses. You have failed, #{@@player}.  The Secret Number was #{@@secret_number}."
      @@losses += 1
    end
  end
end

get '/' do
  erb :game_start
end

post '/' do
  @@player = params[:name]
  @@wins = 0
  @@losses = 0
  check_name(@@player)
  erb :instructions
end

get '/game' do
  @@secret_number = secret_number
  @@guesses = 3
  erb :game
end

post '/game' do
  @@guesses -= 1
  @guess = params[:guess].to_i
  check_number(@guess)
  erb :game
end