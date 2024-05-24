require 'tty-prompt'
require 'yaml'
require 'pastel'

class Quizzer
  SCORES_FILE = File.expand_path("../../scores.yaml", __FILE__)  # Path to the scores file

  def initialize
    @prompt = TTY::Prompt.new
    @pastel = Pastel.new
    @quizzes_dir = File.expand_path("../../quizzes", __FILE__)  # Absolute path to quizzes
    @scores = load_scores  # Load scores from file
  end

  def start
    loop do
      quiz_names = list_quizzes_with_scores
      if quiz_names.empty?
        puts "No quizzes found in the quizzes directory."
        return
      end
      quiz_name = @prompt.select("Which quiz would you like to take? (Press 'q' to quit)", quiz_names)
      
      break if quiz_name == 'q' || quiz_name.nil?
      take_quiz(quiz_name)
    end
  end

  private

  def list_quizzes_with_scores
    quizzes = Dir["#{@quizzes_dir}/*.yaml"].map { |file| File.basename(file, ".yaml") }
    quizzes_with_scores = quizzes.map do |quiz|
      score_display = @scores[quiz] ? " (Score: #{@scores[quiz]})" : ""
      "#{quiz}#{score_display}"
    end
    quizzes_with_scores << 'q'  # Add the 'q' option to the quizzes list
    quizzes_with_scores
  end

  def take_quiz(quiz_name)
    return if quiz_name == 'q'
    quiz_name = quiz_name.split(" (").first  # Remove score display
    questions = load_quiz(quiz_name).shuffle  # Shuffle the questions array
    missed_questions = []

    initial_score, missed_questions = run_quiz(questions)
    @scores[quiz_name] = initial_score
    puts "You scored #{initial_score}/#{questions.size}!"
    save_scores  # Save the scores after the quiz

    while missed_questions.any?
      retry_choice = @prompt.select("Would you like to retry the missed questions?", ["Yes", "No"])
      break if retry_choice == "No"

      new_score, new_missed_questions = run_quiz(missed_questions)
      puts "You scored #{new_score}/#{missed_questions.size} on the retry!"

      missed_questions = new_missed_questions
    end

    puts "Final score: #{@scores[quiz_name]}/#{questions.size}!"
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

  def load_scores
    if File.exist?(SCORES_FILE)
      YAML.load_file(SCORES_FILE) || {}
    else
      {}
    end
  end

  def save_scores
    File.open(SCORES_FILE, 'w') do |file|
      file.write(@scores.to_yaml)
    end
  end
end
