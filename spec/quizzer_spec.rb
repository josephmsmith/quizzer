require 'rspec'
require 'tty-prompt'
require_relative '../lib/quizzer' # loads quizzer class

RSpec.describe Quizzer do
  let(:quizzer) { Quizzer.new }
  let(:prompt) { instance_double(TTY::Prompt) }
  let(:sample_questions) do
    [
      {
        "question" => "What is the capital of France?",
        "choices" => ["Paris", "London", "Berlin", "Madrid"],
        "correct" => "Paris"
      },
      {
        "question" => "Who wrote 'To Kill a Mockingbird'?",
        "choices" => ["Harper Lee", "Mark Twain", "Ernest Hemingway", "F. Scott Fitzgerald"],
        "correct" => "Harper Lee"
      }
    ]
  end

  before do
    allow(TTY::Prompt).to receive(:new).and_return(prompt)
    allow(prompt).to receive(:select).with("What is the capital of France?", ["Paris", "London", "Berlin", "Madrid"]).and_return("Paris")
    allow(prompt).to receive(:select).with("Who wrote 'To Kill a Mockingbird'?", ["Harper Lee", "Mark Twain", "Ernest Hemingway", "F. Scott Fitzgerald"]).and_return("Harper Lee")
    allow(YAML).to receive(:load_file).and_return(sample_questions)
  end

  describe '#list_quizzes' do
    it 'returns a list of quiz names' do
      allow(Dir).to receive(:[]).and_return(["/path/to/quizzes/sample_quiz.yaml"])
      expect(quizzer.send(:list_quizzes)).to eq(['sample_quiz'])
    end
  end

  describe '#load_quiz' do
    it 'loads the questions for a given quiz name' do
      expect(quizzer.send(:load_quiz, 'sample_quiz')).to eq(sample_questions)
    end
  end

  describe '#take_quiz' do
    it 'runs through the questions and calculates the score' do
      expect { quizzer.send(:take_quiz, 'sample_quiz') }.to output(/You scored 2\/2!/).to_stdout
    end
  end
end
