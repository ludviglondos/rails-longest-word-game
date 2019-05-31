require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    char_array = ('A'..'Z').to_a
    @letters = []
    until @letters.count == 10 do @letters << char_array.sample(1) end
    @letters
  end

  def score
    if !check_attempt_letters?(params[:word], params[:letters])
      @result = "Sorry but #{params[:word]} can´t be built out of #{params[:letters]}"
    elsif !check_attempt_word_ok?(params[:word])
      @result = "Sorry but #{params[:word]} does not seem to be a valid English word..."
    else
      @result = "Congratulations! #{params[:word]} is a valid English Word!"
    end
  end

  def check_attempt_letters?(attempt, grid)
    attempt.upcase.split("").each do |letter|
      return false if attempt.upcase.count(letter) > grid.lstrip.count(letter)
    end
    true
  end

  def check_attempt_word_ok?(attempt)
    url = 'https://wagon-dictionary.herokuapp.com/'
    word_api = JSON.parse(open("#{url}#{attempt}").read)
    if word_api['found'] == true
      return true
    else
      return false
    end
  end
end
