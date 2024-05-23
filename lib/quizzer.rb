require 'tty-prompt'
require 'yaml'
require 'pastel'

class Quizzer
  def initialize
    @prompt = TTY::Prompt.new
    @pastel = Pastel.new
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
    questions = load_quiz(quiz_name).shuffle  # Shuffle the questions array
    missed_questions = []

    total_score, missed_questions = run_quiz(questions)
    puts "You scored #{total_score}/#{questions.size}!"

    while missed_questions.any?
      retry_choice = @prompt.select("Would you like to retry the missed questions?", ["Yes", "No"])
      break if retry_choice == "No"

      new_score, new_missed_questions = run_quiz(missed_questions)
      total_score += new_score
      puts "You scored #{new_score}/#{missed_questions.size} on the retry!"

      missed_questions = new_missed_questions
    end

    puts "Final score: #{total_score}/#{questions.size}!"
  end

  def run_quiz(questions)
    score = 0
    missed_questions = []

    questions.each do |question|
      shuffled_choices = question["choices"].shuffle
      answer = @prompt.select(question["question"], shuffled_choices)
      if answer == question["correct"]
        puts @pastel.green("Correct! The answer is #{answer}.")
        score += 1
      else
        puts @pastel.red("Incorrect. You answered #{answer}. The correct answer is #{question['correct']}.")
        missed_questions << question
      end
    end

    return score, missed_questions
  end

  def load_quiz(quiz_name)
    file_path = "#{@quizzes_dir}/#{quiz_name}.yaml"
    YAML.load_file(file_path)
  end
end

