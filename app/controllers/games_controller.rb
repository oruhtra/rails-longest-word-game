require "open-uri"
require "json"

class GamesController < ApplicationController
  LETTERS = ("a".."z").to_a

  def new
    @grid = [];
    8.times do
      @grid.push(LETTERS.sample)
    end
  end

  def score
    @answer = params[:answer]
    @grid = params[:grid]
    @correct = check_word_length?(@answer, @grid) && word_in_grid?(@answer, @grid) && word_english?(@answer)
  end

  private

  def check_word_length?(word, grid)
    if word.length <= grid.length
      return true
    else
      return false
    end
  end

  def word_in_grid?(word, grid)
    word_array = word.split("")
    test_grid = grid.dup.split("")
    is_true = true
    word_array.each do |letter|
      i = test_grid.find_index(letter)
      if i
        test_grid.slice!(i)
      else
        is_true = false
      end
    end
    return is_true
  end

  def word_english?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    result_serialized = open(url).read
    result = JSON.parse(result_serialized)
    return result["found"]
  end

end
