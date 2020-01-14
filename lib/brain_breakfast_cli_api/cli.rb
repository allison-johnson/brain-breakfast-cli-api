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
      puts "\nHere is a list of categories:"
      category_menu
      puts "Please enter a category number to see a question from that category, or type '0' for a random category."
      the_question = find_question(category_input)
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

  def find_question(category_num)
    API.new.get_question(category_num) #This needs to return a TriviaQuestion object!
  end #find_question

  def get_user_answer
    puts "\nPlease select the best answer to the question"
    user_answer = gets.strip
  end

  def check_answer(question, answer)
    #binding.pry
    if question.correct?(answer)
      puts "Correct!"
    else
      puts "I'm sorry, that's incorrect."
    end #if
  end #check_answer

  def invalid_choice
    puts "Sorry, that wasn't one of the options."
  end #invalid_choice

  def goodbye
    puts "Thanks for using the Brain Breakfast API gem. See you next time!"
    exit 
  end #goodbye

end #class