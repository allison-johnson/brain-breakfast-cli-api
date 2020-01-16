require 'rest-client'
require 'json'
require 'pry'
require_relative './trivia_question'

#Option to receive a question or a quiz
#Option to take a 10-question quiz
#Option to see how many questions you can answer correctly in one minute

class API
  def get_questions(category_num, diff)
    actual_num = category_num.to_i + 8

    if diff == "E"
      difficulty = "easy"
    elsif diff == "M"
      difficulty = "medium"
    else
      difficulty = "hard"
    end #if diff

    #response is going to store ONE question. Can change this by adding to URL.
    if actual_num > 8
      response = RestClient.get("https://opentdb.com/api.php?amount=5&encode=base64&category=#{actual_num}&difficulty=#{difficulty}&type=multiple")
    else
      response = RestClient.get("https://opentdb.com/api.php?amount=5&encode=base64&difficulty=#{difficulty}&type=multiple")
    end #if

    puts response
    #questions_array is an array questions in JSON format
    questions_array = JSON.parse(response.body)["results"]
    response_code = JSON.parse(response.body)["response_code"].to_i
    
    binding.pry

    #will store TriviaQuestion objects
    trivia_array = [] 

    questions_array.each do |question_hash|
      t = TriviaQuestion.new(question_hash)
      trivia_array << t 
    end #each

    trivia_array 
  end #get_questions

end #class
