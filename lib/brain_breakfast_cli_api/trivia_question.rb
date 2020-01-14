#Model class, with ability to persist instances into a class variable

class TriviaQuestion
  attr_accessor :category, :type, :difficulty, :question, :correct_answer, :incorrect_answers, :answer_choices
  @@all = []

  def initialize(attr_hash)
    @category = attr_hash["category"]
    @question = attr_hash["question"]
    @correct_answer = attr_hash["correct_answer"]
    @incorrect_answers = attr_hash["incorrect_answers"]
    @answer_choices = [self.correct_answer] + self.incorrect_answers
    answer_choices.sort_by!{rand}
    binding.pry 
    # attr_hash.each do |key, value|
    #   self.send("#{key}=", value)
    #   binding.pry 
    #   answer_choices = [self.correct_answer] + self.incorrect_answers
    #   answer_choices.sort_by!{rand}
    # end #each
    self.save
  end #init

  def correct?(answer)
    if answer.upcase == correct_answer
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