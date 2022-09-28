require 'yaml'

# Contains the intro and the method to display the game
module Game
  def intro
    puts "Playing Hangman in the console\n\n"
    puts 'A secret word is automatically chosen and you have to guess one letter
at each turn. You are allowed only 8 incorrect guesses. To win, you must find all
letters in the word before using up all your allowed incorrect guesses'
    puts "====================================\n\n"
  end

  def display(dashes, incorrect_letters)
    separator = '===================================='
    puts "\n\nSecret Word: #{dashes.join(' ')}"
    puts separator
    puts "Incorrect Guesses: #{incorrect_letters.join(' ')}"
    puts "#{separator}\n\n"
  end
end

# Contains the game logic
class Hangman
  include Game

  def initialize
    @word
    @incorrect_letters
    @dashes
    intro
    play_game
  end

  private

  def find_word
    dictionary = File.open('dictionary.txt')
    word_array = dictionary.readlines.collect(&:chomp)
    filtered_array = word_array.select do |word|
      word.size.between?(5, 12)
    end
    filtered_array.sample.downcase
  end

  def make_guess
    puts "\n[Type 'save' to save progress]\n
Guess a letter that might be part of the secret word"
    guess = gets.chomp
    guess
  end

  def play_game
    @word = find_word
    @dashes = Array.new(@word.length) { '_' }
    @incorrect_letters = []
    beginning = true

    while @incorrect_letters.length < 8
      if beginning == true
        puts 'Lets Begin!'
        puts 'Pick [1] to start a new game or [2] to load an existing one:'
        choice = gets.chomp.to_i

        load_game if choice == 2
        beginning = false
      end

      guess = make_guess.downcase

      if guess == 'save'
        save_game([@dashes, @incorrect_letters, @word])
      elsif guess.to_i != 0 || guess == '0'
        puts "\nInput Error: Use only letters"
      elsif guess.length > 1
        puts "\nInput only ONE letter"
      elsif @incorrect_letters.include?(guess) || @dashes.include?(guess)
        puts "\nYou've Already Guessed That Letter"
      elsif !@word.include?(guess)
        @incorrect_letters << guess
      else
        @word.chars.each_with_index do |letter, i|
          @dashes[i] = guess if guess == letter
        end
      end
      display(@dashes, @incorrect_letters)
      if @dashes == @word.chars
        puts "\nYou Win! The secret word was #{@word}"
        break
      end
    end
    puts "\nYou lose! The secret word was #{@word}" unless @dashes == @word.chars
  end

  def save_game(objects)
    Dir.mkdir('games') unless Dir.exist?('games')
    yaml = YAML.dump(objects)
    filename = 'games/saved_game.yaml'

    File.open(filename, 'w') { |f| f.puts yaml }
  end

  def load_game
    if File.exist?('games/saved_game.yaml')
      saved_game = File.open('games/saved_game.yaml') { |f| YAML.safe_load(f) }
      @dashes = saved_game[0]
      @incorrect_letters = saved_game[1]
      @word = saved_game[2]
      display(@dashes, @incorrect_letters)
    else
      puts "\n\nThere are no saved games currently\n\n"
    end
  end
end

Hangman.new
