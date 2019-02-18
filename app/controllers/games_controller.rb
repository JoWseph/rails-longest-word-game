require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @array = []
    10.times { @array << rand(65...90).chr }
  end

  def score
    word = params[:word]
    grid = params[:grid].split(' ')
    if check_grid(word, grid)
      @score = check_exist(word)[:length]
      @message = check_exist(word)[:message]
    else
      @score = 0
      @message = 'not in the grid'
    end
  end

  private

  def check_grid(attempt, grid)
    allowed = Hash.new(0)
    grid.each { |letter| allowed[letter] += 1 }
    attempt.chars.each { |char| allowed[char.upcase] -= 1 }
    allowed.values.all? { |value| value >= 0 }
  end

  def check_exist(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    serialized_result = open(url).read
    if JSON.parse(serialized_result)['found']
      return { length: attempt.size, message: 'well done' }
    else
      return { length: 0, message: 'not an english word' }
    end
  end
end
