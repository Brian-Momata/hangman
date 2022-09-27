require 'yaml'

module Game
  def intro
    puts 'Playing Hangman in the console'
    puts 'A secret word is automatically chosen and you have to guess one letter
at each turn. You are allowed only 8 incorrect guesses. To win, you must find all
letters in the word before using up all your allowed incorrect guesses'
    puts '===================================='
  end

  def display(dashes, incorrect_letters)
    separator = '===================================='
    puts "Secret Word: #{dashes.join(' ')}"
    puts separator
    puts "Incorrect Guesses: #{incorrect_letters.join(' ')}"
    puts separator
  end
end

class Hangman
  include Game

  def initialize player
    intro
    play_game player
  end

  private

  def find_word
    dictionary = File.open('dictionary.txt')
    word_array = dictionary.readlines.collect(&:chomp)
    filtered_array = word_array.select do |word|
      word if word.size >= 5 && word.size <= 12
    end
    filtered_array.sample.downcase
  end

  def play_game(player)
    word = find_word
    dashes = Array.new(word.length) { '_' }
    incorrect_letters = []
    beginning = true

    while incorrect_letters.length < 8
      while beginning == true
        puts 'Lets Begin!'
        puts 'Pick [1] to start a new game or [2] to load an existing one:'
        choice = gets.chomp.to_i

        if choice == 2
          begin
            saved_game = load_game
            dashes = saved_game[0]
            incorrect_letters = saved_game[1]
            word = saved_game[2]
            beginning = false
            display(dashes, incorrect_letters)
          rescue
            puts 'There are no saved games currently'
            beginning = false
          end
        else
          beginning = false
          break
        end
      end

      guess = player.guess.downcase

      if guess == 'save'
        save_game([dashes, incorrect_letters, word])
      elsif guess.to_i != 0 || guess == '0'
        puts 'Input Error: Use only letters'
      elsif guess.length > 1
        puts 'Input only ONE letter'
      elsif incorrect_letters.include?(guess) || dashes.include?(guess)
        puts "You've Already Guessed That Letter"
      elsif !word.include?(guess)
        incorrect_letters << guess
      else
        word.chars.each_with_index do |letter, i|
          dashes[i] = guess if guess == letter
        end
      end
      display(dashes, incorrect_letters)
      if dashes == word.chars
        puts "You Win! The secret word was #{word}"
        break
      end
    end
    puts "You lose! The secret word was #{word}" unless dashes == word.chars
  end

  def save_game(objects)
    Dir.mkdir('games') unless Dir.exist?('games')
    yaml = YAML.dump(objects)
    filename = 'games/saved_game.yaml'

    File.open(filename, 'w') { |f| f.puts yaml }
  end

  def load_game
    File.open('games/saved_game.yaml') { |f| YAML.safe_load(f) }
  end
end

class Player
  def guess
    puts "[Type 'save' to save progress]
Guess a letter that might be part of the secret word"
    guess = gets.chomp
    guess
  end
end
player = Player.new
Hangman.new(player)
