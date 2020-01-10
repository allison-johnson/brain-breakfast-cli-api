#Model class, with ability to persist instances into a class variable

class TriviaQuestion
  attr_accessor :category, :type, :difficulty, :question, :correct_answer, :incorrect_answers
  @@all = []

  def initialize(attr_hash)
    attr_hash.each do |key, value|
      self.send("#{key}=", value)
    end #each
    self.save
  end #init

  def save
    @@all << self 
  end #save

  def self.all
    @@all 
  end #self.all

end #class