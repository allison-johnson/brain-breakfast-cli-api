class CLI

  def start
    system('clear')
    puts "\nWelcome to the Brain Breakfast API!"
    puts %Q(
            \(   \) \(    \)  \)
             \) \(   \)  \(  \(
             \( \)  \(    \) \)
             _____________
            <_____________> ___
            |             |/ _ \\
            |               | | |
            |               |_| |
         ___|             |\\___/
        /    \\___________/    \\
        \\_____________________/
    )
    main_menu_options
  end #start

  def main_menu_options
    print "Type 'play' to enjoy some trivia questions with your breakfast, or type 'exit': "
    main_menu_input
  end #main_menu_options 

  def main_menu_input
    user_input = gets.strip

    if user_input.downcase == "play"
      puts "\nGet ready for a 5-question quiz. You'll receive points for each question as follows:"
      puts %Q(
        +2 points - Correct answer
        -1 point - Each incorrect answer
        -0.5 points - Hint received
        MAXIMUM SCORE: 10 points
      )
      print "How much of a challenge are you up for this morning? Select 'E'asy, 'M'edium, or 'H'ard: "
      diff = difficulty_input.upcase 
      puts "\nHere is a list of categories:"
      category_menu
      print "Please enter a category number to see a question from that category, or type '0' for a random category: "
      
      the_questions = find_questions(category_input, diff)
      the_questions.each.with_index(1) do |question, index|
        puts "**************************************\nQuestion Number #{index}"
        question.display
        check_answer(question, get_user_answer)
        question.display_points
      end #each

      display_score 
      thank_you
      main_menu_options 

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
    while(user_input.to_i < 0 || user_input.to_i > 24)
      print "Invalid input. Please enter a valid category number: "
      user_input = gets.strip 
    end #while
    user_input 
  end #category_input

  def difficulty_input
    user_input = gets.strip
    while(!['E','M','H'].include?(user_input.upcase))
      print "Invalid input. Please enter 'E', 'M', or 'H': "
      user_input = gets.strip 
    end #while 
    user_input 
  end #difficulty_input

  def find_questions(category_num, question_diff)
    API.new.get_questions(category_num, question_diff) #This needs to return a TriviaQuestion object!
  end #find_question

  def get_user_answer
    print "\nPlease select the best answer to the question: "
    user_answer = gets.strip
    while(!['A','B','C','D'].include?(user_answer.upcase))
      print "Invalid answer. Please enter 'A', 'B', 'C', or 'D': "
      user_answer = gets.strip 
    end #while
    user_answer 
  end #get_user_answer

  def check_answer(question, answer)
    #binding.pry
    if question.correct?(answer)
      puts "Correct!"
      question.update_points(2.0)
    else
      puts "I'm sorry, that's incorrect."
      question.add_attempt
      question.update_points(-1.0)
      if question.attempts < 2 
        print "Care for a hint? Please type 'Y' or 'N': "
        if get_hint_input.upcase == "Y"
          print "Eliminating an incorrect answer choice..."
          question.update_points(-0.5)
          question.get_hint(answer) 
        end #if
        check_answer(question, get_user_answer)
      else
        question.state_answer 
      end #if
    end #if
  end #check_answer

  def get_hint_input
    user_input = gets.strip
    while(!['Y','N'].include?(user_input.upcase))
      print "Invalid input. Please enter 'Y' or 'N': "
      user_input = gets.strip 
    end #while 
    user_input 
  end #get_hint_input

  def display_score
    puts "\nTOTAL SCORE: #{TriviaQuestion.total_score}"
  end #display_score 

  def thank_you
    puts "\nThank you for playing Brain Breakfast!\n"
  end #thank_you

  def invalid_choice
    puts "Sorry, that wasn't one of the options."
  end #invalid_choice

  def goodbye
    puts "Thanks for using the Brain Breakfast API gem. See you next time!"
    exit 
  end #goodbye

end #class