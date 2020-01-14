#Model class, with ability to persist instances into a class variable

class TriviaQuestion
  attr_accessor :category, :type, :difficulty, :question, :correct_answer, :incorrect_answers, :answer_choices, :attempts, :points 
  @@all = []
  @@score = 0.0

  def initialize(attr_hash)
    @category = attr_hash["category"]
    @question = attr_hash["question"]
    @difficulty = attr_hash["difficulty"]
    @correct_answer = attr_hash["correct_answer"]
    @incorrect_answers = attr_hash["incorrect_answers"]
    @attempts = 0
    @points = 0 

    @answer_choices = generate_answer_hash 

    # Creating an answer choices ARRAY - problem is that letters are not stored
    # @answer_choices = [self.correct_answer] + self.incorrect_answers
    # answer_choices.sort_by!{rand}
    
    # binding.pry 
  
    # attr_hash.each do |key, value|
    #   self.send("#{key}=", value)
    #   binding.pry 
    #   answer_choices = [self.correct_answer] + self.incorrect_answers
    #   answer_choices.sort_by!{rand}
    # end #each
    self.save
  end #init

  def decode(text)
    Base64.decode64(text)
  end #decode

  def display
    puts "\nCategory: #{decode(category)}\tCorrect Answer: #{decode(correct_answer)}"
    puts "Question: #{decode(question)}\n" 
    display_choices
  end #display

  def display_choices 
    all_choices = {}
    all_choices = answer_choices[:correct].merge(answer_choices[:incorrect])
    all_choices = all_choices.sort_by{|key, val| key}

    all_choices.each do |letter_with_ans|
      puts "\n\t#{letter_with_ans[0]}. #{decode(letter_with_ans[1])}"
    end #each
  end #display_choices

  def display_points
    if points.to_i == points
      puts "\nPoints for this question: #{points.to_i} point(s)"
    else
      puts "\nPoints for this question: #{points} point(s)"
    end #if
  end #display_points

  def add_attempt
    @attempts = @attempts + 1
  end #add_attempt

  def update_points(n)
    @points += n
  end #update_score

  def generate_answer_hash
    answer_choices = {}

    letters = ["A", "B", "C", "D"]
    correct_letter = letters.sample
    letters = letters - [correct_letter]

    answer_choices[:correct] = {correct_letter => correct_answer}
    answer_choices[:incorrect] = {}

    incorrect_answers.each do |ans|
      letter = letters.sample
      letters = letters - [letter]
      answer_choices[:incorrect][letter] = ans 
    end #each

    answer_choices
  end #generate_answer_hash

  def correct?(answer)
    if answer.upcase == answer_choices[:correct].keys[0]
      true 
    else
      false
    end
  end

  def get_hint(incorrect_letter)
    hint_letters = ["A","B","C","D"] - [incorrect_letter.upcase, answer_choices[:correct].keys[0]]
    hint = hint_letters.sample
    puts "Choice (#{hint}) is incorrect!"
  end #get_hint

  def save
    @@all << self 
  end #save

  def self.all
    @@all 
  end #self.all

  def self.score
    @@score
  end #self.score

  def self.total_score
    self.all.each do |question|
      @@score += question.points  
    end #each
    @@score.to_i == @@score ? @@score.to_i : @@score
  end #total_score

end #class