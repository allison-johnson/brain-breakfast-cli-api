#Model class, with ability to persist instances into a class variable

class TriviaQuestion
  attr_accessor :category, :type, :difficulty, :question, :correct_answer, :incorrect_answers, :answer_choices, :attempts 
  @@all = []

  def initialize(attr_hash)
    @category = attr_hash["category"]
    @question = attr_hash["question"]
    @difficulty = attr_hash["difficulty"]
    @correct_answer = attr_hash["correct_answer"]
    @incorrect_answers = attr_hash["incorrect_answers"]
    @attempts = 0

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

  def add_attempt
    @attempts = @attempts + 1
  end #add_attempt

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

  def save
    @@all << self 
  end #save

  def self.all
    @@all 
  end #self.all

end #class