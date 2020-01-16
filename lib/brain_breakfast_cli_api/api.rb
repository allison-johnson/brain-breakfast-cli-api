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

    #response is going to store FIVE questions. Can change this by in URL.
    if actual_num > 8
      response = RestClient.get("https://opentdb.com/api.php?amount=5&encode=base64&category=#{actual_num}&difficulty=#{difficulty}&type=multiple")
    else
      response = RestClient.get("https://opentdb.com/api.php?amount=5&encode=base64&difficulty=#{difficulty}&type=multiple")
    end #if

    response_code = JSON.parse(response.body)["response_code"].to_i

    if response_code == 0 #Indicates a valid request to the API
      #questions_array is an array questions in JSON format
      questions_array = JSON.parse(response.body)["results"]

    elsif response_code == 1 #Indicates that there were not enough questions of that category/difficulty
      category_info = RestClient.get("https://opentdb.com/api_count.php?category=#{actual_num}")
      category_question_counts = JSON.parse(category_info.body)["category_question_count"]
      max_num = category_question_counts["total_#{difficulty}_question_count"].to_i
      remainder = 5 - max_num 

      #Get the maximum number of questions of that category/difficulty from the API and store them in questions_array
      response_1 = RestClient.get("https://opentdb.com/api.php?amount=#{max_num}&encode=base64&category=#{actual_num}&difficulty=#{difficulty}&type=multiple")
      questions_array = JSON.parse(response_1.body)["results"]

      #Get the remainder of the questions from a random category and add those to questions_array
      response_2 = RestClient.get("https://opentdb.com/api.php?amount=#{remainder}&encode=base64&difficulty=#{difficulty}&type=multiple")
      questions_array += JSON.parse(response_2.body)["results"]

    end #if

    #will store TriviaQuestion objects
    trivia_array = [] 

    questions_array.each do |question_hash|
      t = TriviaQuestion.new(question_hash)
      trivia_array << t 
    end #each

    trivia_array 
  end #get_questions

end #class
