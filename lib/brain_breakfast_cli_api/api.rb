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

    questions_array = JSON.parse(response.body)["results"]
    trivia_array = [] #will store TriviaQuestion objects

    questions_array.each do |question_hash|
      binding.pry 
      t = TriviaQuestion.new(question_hash)
      trivia_array << t 
      # answer_choices = [t.correct_answer] + t.incorrect_answers
      # answer_choices.sort_by!{rand}
      puts "\nCategory: #{t.category}\t\tCorrect Answer: #{t.correct_answer}"
      puts "Question: #{t.question}\n" 
      display_choices(t.answer_choices)
    end #each

    trivia_array[0]
  end #get_question

  def display_choices(choices) #Refactor with choices = answer_choices hash
    all_choices = {}
    all_choices = choices[:correct].merge(choices[:incorrect])
    all_choices = all_choices.sort_by{|key, val| key}

    all_choices.each do |letter_with_ans|
      puts "\n\t#{letter_with_ans[0]}. #{letter_with_ans[1]}"
    end #each
  
    # binding.pry

    # puts "\n\tA. #{choices[0]}"
    # puts "\tB. #{choices[1]}"
    # puts "\tC. #{choices[2]}"
    # puts "\tD. #{choices[3]}"
  end #display_choices

end #class
