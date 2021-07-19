# frozen_string_literal: true

# class recipe describes the recipe
class Recipe
  attr_reader :name, :description, :done, :prep_time, :rating

  def initialize(name, description, prep_time = '', rating = '', done = 'false')
    @name = name
    @description = description
    @rating = rating
    @done = done
    @prep_time = prep_time
  end

  def make!
    @done = @done == 'true' ? 'false' : 'true'
  end

  def rating?
    @rating == '' ? 'no rating found' : "#{@rating}/5"
  end
end
