require 'yaml'

class Hangman
  def initialize player
    play_game player
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

  def play_game player
    word = get_word
    dashes = Array.new(word.length) { "_" }
    incorrect_letters = Array.new

    while incorrect_letters.length < 8
      guess = player.guess.downcase

      if guess == 'save'
        save_game([dashes, incorrect_letters, word])
      elsif guess == 'load'
        begin 
          saved_game = load_game
          dashes = saved_game[0]
          incorrect_letters = saved_game[1]
          word = saved_game[2]
        rescue
          dashes = Array.new(word.length) { "_" }
          incorrect_letters = Array.new
          word = get_word
        end
      elsif guess.to_i != 0 || guess == "0"
        puts "Input Error: Use only letters"
      elsif guess.length > 1
        puts "Input only ONE letter"
      elsif incorrect_letters.include?(guess) || dashes.include?(guess)
        puts "You've Already Guessed That Letter"
      elsif !word.downcase.include?(guess)
        incorrect_letters << guess
      else
        word.downcase.chars.each_with_index do |letter, i|
          dashes[i] = guess if guess == letter
        end
      end
      if dashes == word.downcase.chars
        puts "You Win! The secret word was #{word}"
        break
      else
        separator = '===================================='
        puts separator
        puts "Secret Word: #{dashes.join(" ")}"
        puts separator
        puts "Incorrect Guesses: #{incorrect_letters.join(" ")}"
        puts separator
      end
    end
    puts "You lose! The secret word was #{word}" unless dashes == word.downcase.chars
  end

  def save_game(objects)
    Dir.mkdir('games') unless Dir.exist?('games')
    yaml = YAML.dump(objects)
    filename = 'games/saved_game.yaml'

    File.open(filename, 'w') { |f| f.puts yaml }
  end

  def load_game
    File.open('games/saved_game.yaml') { |f| YAML.load(f) }
  end
end

class Player
  def guess
    puts "[Use 'save' to save progress and 'load' load an existing game]
Guess a letter that might be part of the secret word"
    guess = gets.chomp
    guess
  end
end
player = Player.new
Hangman.new(player)
