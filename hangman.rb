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

  def play_game(player, word)
    dashes = Array.new(word.length) { "_" }
    incorrect_letters = Array.new

    while incorrect_letters.length < 8
      guess = player.guess

      if guess.length > 1
        puts "Input only ONE letter"
      elsif incorrect_letters.include?(guess) || dashes.include?(guess)
        puts "You've Already Guessed That Letter"
      elsif !word.include?(guess)
        incorrect_letters << guess
      else
        word.chars.each_with_index do |letter, i|
          dashes[i] = guess if guess == letter
        end
      end
      puts dashes.join(" ")
      puts "Incorrect Guesses: #{incorrect_letters.join(" ")}"
    end
  end
end

class Player
  def guess
    puts "Guess one letter that might be part of the secret word"
    guess = gets.chomp
    guess
  end
end