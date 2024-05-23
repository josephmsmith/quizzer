require 'tty-prompt'
require 'yaml'

class Quizzer
  def initialize
    @prompt = TTY::Prompt.new
    @quizzes_dir = File.expand_path("../../quizzes", __FILE__)  # this needs to be absolute path
  end

  def start
    quiz_names = list_quizzes
    if quiz_names.empty?
      puts "No quizzes found in the quizzes directory."
      return
    end
    quiz_name = @prompt.select("Which quiz would you like to take?", quiz_names)
    take_quiz(quiz_name)
  end

  private

  def list_quizzes
    quizzes = Dir["#{@quizzes_dir}/*.yaml"].map { |file| File.basename(file, ".yaml") }
    puts "Available quizzes: #{quizzes.inspect}"  # Debugging line
    quizzes
  end

  def take_quiz(quiz_name)
    questions = load_quiz(quiz_name)#.shuffle #shuffle the questions array
    score = 0

    questions.each do |question|
        shuffled_choices = question["choices"]#.shuffle    
        answer = @prompt.select(question["question"], shuffled_choices)
        score += 1 if answer == question["correct"]
    end

    puts "You scored #{score}/#{questions.size}!"
  end

  def load_quiz(quiz_name)
    file_path = "#{@quizzes_dir}/#{quiz_name}.yaml"
    YAML.load_file(file_path)
  end
end
