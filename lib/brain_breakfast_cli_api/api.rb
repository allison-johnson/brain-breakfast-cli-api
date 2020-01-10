require 'rest-client'
require 'json'
require 'pry'
require_relative './trivia_question'

#Brain breakfast
#Log in in the morning and select a category
#Or have a category generated for you
#Select specifiers (easy, hard, etc.)
#Receive a random question

#Option to receive a question or a quiz
#Option to eliminate a wrong answer choice as a hint
#Option to take a 10-question quiz
#Option to see how many questions you can answer correctly in one minute

#Getting the info...

# def get_questions

# end #get_questions

class API
  def get_question(category_num)
    actual_num = category_num.to_i + 8
    if actual_num > 8
      response = RestClient.get("https://opentdb.com/api.php?amount=1&category=#{actual_num}&type=multiple")
    else
        response = RestClient.get("https://opentdb.com/api.php?amount=1&type=multiple")
    end #if
    questions_array = JSON.parse(response)["results"]

    questions_array.each do |question_hash|
      t = TriviaQuestion.new(question_hash)
      puts t.question
      puts t.category
      puts t.correct_answer 
    end #each
  #binding.pry
  end #get_question

end #class
