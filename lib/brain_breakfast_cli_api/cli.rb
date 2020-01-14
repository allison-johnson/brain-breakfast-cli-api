class CLI

  def start
    system('clear')
    puts "Welcome to the Brain Breakfast API!\n"
    main_menu_options
  end #start

  def main_menu_options
    puts "Type 'play' to enjoy some trivia questions with your breakfast."
    puts "Type 'exit' to exit the program."
    main_menu_input
  end #main_menu_options 

  def main_menu_input
    user_input = gets.strip
    if user_input.downcase == "play"
      puts "\nHow much of a challenge are you up for this morning? Select 'E'asy, 'M'edium, or 'H'ard"
      diff = difficulty_input.upcase 
      puts "\nHere is a list of categories:"
      category_menu
      puts "Please enter a category number to see a question from that category, or type '0' for a random category."
      the_question = find_question(category_input, diff)
      check_answer(the_question, get_user_answer)
    elsif user_input.downcase == "exit"
      goodbye
    else
      invalid_choice
      main_menu_options
    end #if
  end #main_menu_input

  def category_menu
    puts %Q(
        \(1\) General Knowledge
        \(2\) Books
        \(3\) Film
        \(4\) Music
        \(5\) Musicals and Theatre
        \(6\) Television
        \(7\) Video Games
        \(8\) Board Games
        \(9\) Science & Nature
        \(10\) Computers
        \(11\) Mathematics
        \(12\) Mythology
        \(13\) Sports
        \(14\) Geography
        \(15\) History
        \(16\) Politics
        \(17\) Art
        \(18\) Celebrities
        \(19\) Animals
        \(20\) Vehicles
        \(21\) Comics
        \(22\) Gadgets
        \(23\) Anime & Manga
        \(24\) Cartoon & Animations
    )
  end #category_menu

  def category_input
    user_input = gets.strip
  end #category_input

  def difficulty_input
    user_input = gets.strip
    while(!['E','M','H'].include?(user_input.upcase))
      puts "Invalid input. Please enter 'E', 'M', or 'H'."
      user_input = gets.strip 
    end #while 
    user_input 
  end #difficulty_input

  def find_question(category_num, question_diff)
    API.new.get_question(category_num, question_diff) #This needs to return a TriviaQuestion object!
  end #find_question

  def get_user_answer
    puts "\nPlease select the best answer to the question."
    user_answer = gets.strip
  end

  def check_answer(question, answer)
    #binding.pry
    if question.correct?(answer)
      puts "Correct!"
    else
      puts "I'm sorry, that's incorrect."
      question.add_attempt
      if question.attempts < 2 
        puts "Care for a hint? Please type 'Y' or 'N'."
        if get_hint_input.upcase == "Y"
          puts "Eliminating an incorrect answer choice..."
          question.get_hint(answer) 
        end #if
        check_answer(question, get_user_answer)
      else
        state_answer(question)
      end #if
    end #if
  end #check_answer

  def get_hint_input
    user_input = gets.strip
    while(!['Y','N'].include?(user_input.upcase))
      puts "Invalid input. Please enter 'Y' or 'N'."
      user_input = gets.strip 
    end #while 
    user_input 
  end #get_hint_input

  def state_answer(question)
    puts "\nThe correct answer is (#{question.answer_choices[:correct].keys[0]}) #{question.correct_answer}."
  end #state_answer

  def invalid_choice
    puts "Sorry, that wasn't one of the options."
  end #invalid_choice

  def goodbye
    puts "Thanks for using the Brain Breakfast API gem. See you next time!"
    exit 
  end #goodbye

end #class