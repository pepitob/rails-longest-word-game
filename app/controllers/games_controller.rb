require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << Array("A".."Z").sample }
    @letters
  end

  def score
    @attempt = params[:answer]
    @letters = params[:letters]
    @message = if included?(@attempt.upcase, @letters)
                 if english_word?(@attempt)
                   "Congratulations! #{@attempt} is a valid English word."
                 else
                   "#{@attempt} is not an English word."
                 end
               else
                 'You used letters that are not in the grid'
               end
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end
end
