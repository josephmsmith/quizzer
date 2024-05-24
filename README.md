# Quizzer

Hey there! Welcome to Quizzer, your friendly command-line quiz app. This app is designed to help you learn programming fundamentals through interactive quizzes in your terminal. It's super easy to get started. Here's how you can set it up and start quizzing!

## Setup

1. **Clone the repository**

    ```sh
    git clone https://github.com/yourusername/quizzer.git
    cd quizzer
    ```

2. **Install dependencies**

    Make sure you have Bundler installed. If not, you can install it by running:

    ```sh
    gem install bundler
    ```

    Then, install the necessary gems:

    ```sh
    bundle install
    ```

3. **Run the Quizzer**

    To start the quiz, just run:

    ```sh
    bin/quizzer
    ```

## Adding Your Own Quizzes

Want to add your own quizzes? Just create a new YAML file in the `quizzes` directory with your questions. Here’s a sample format to get you started:

```yaml
questions:
  - question: "What is the best city in America"
    choices:
      - "New York"
      - "Los Angeles"
      - "San Francisco"
      - "San Diego"
    correct: "San Diego"
