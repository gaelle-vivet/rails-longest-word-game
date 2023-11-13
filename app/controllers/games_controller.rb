require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = [*('A'..'Z')].sample(10).join
  end

  def score
    @word = params[:word]
    letters = params[:letters].chars
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    result_file = URI.open(url).read
    result = JSON.parse(result_file)
    if result["found"] == true
      if valid_word?(letters,@word)
        @message = "#{@word} is a valid english word!"
      else
        @message = "Sorry but #{@word} can not be build ou of #{letters}"
      end
    else
      @message = "Sorry but #{@word} is not a valid english word"
    end
  end
  
  private

  def valid_word?(letters, word)
    word.upcase.scan(/\w/).map do |letter|
      return false unless letters.include?(letter)
      letters.delete_at(letters.index(letter))
    end
    true
  end
end
