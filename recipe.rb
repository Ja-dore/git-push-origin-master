class Recipe
  attr_reader :name, :description, :rating, :done, :prep_time

  def initialize(name, description, prep_time = "", rating = "", done = "false")
    @name = name
    @description = description
    @rating = rating
    @done = done
    @prep_time = prep_time
  end

  def make!
    @done = "true"
  end
end
