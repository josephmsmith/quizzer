require 'tty-prompt'

class Quizzer
    def initialize
        @prompt = TTY::Prompt.new
    end

    def start
        quiz_name = @prompt.select("Which quiz would you like to take?", list_quizzes)
        take_quiz(quiz_name)
    end

    private
    def list_quizzes
        Dir["quizzes/*.yaml"].map{|file| File.basename(file,".yaml")}
    end

    def take_quiz(quiz_name)
        questions = load_quiz(quiz_name)
        score = 0

        questions.each do |question|
            answer = @prompt.select(question[:question], question[:choices])
            score += 1 if answer == question[:correct]
        end

        puts "you scored #{score}/#{questions.size}!"
    end
    
    def load_quiz(quiz_name)
        file_path = "quizzes/#{quiz_name}.yaml"
        YAML.load_file(file_path)
    end
end
