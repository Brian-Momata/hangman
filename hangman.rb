class Hangman
  def initialize player
    word = get_word
    play_game(player, word)
  end

  private

  def get_word
    dictionary = File.open("dictionary.txt")
    word_array = dictionary.readlines.collect do |word|
      word.chomp
    end
    filtered_array = word_array.select do |word|
      word if word.size >= 5 && word.size <= 12
    end
    filtered_array.sample
  end
end

class Player
  def guess
    puts "Guess one letter that might be part of the secret word"
    guess = gets.chomp
    guess
  end
end