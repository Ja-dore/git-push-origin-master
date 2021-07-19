require_relative 'recipe'
require 'csv'

class Cookbook
  def initialize(csv_file_path)
    @recipes = []
    CSV.foreach(csv_file_path) do |row|
      @recipes << Recipe.new(row[0], row[1], row[2], row[3], row[4])
    end
    @csv_file_path = csv_file_path
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    update_csv
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    update_csv
  end

  def update_recipe(recipe_index)
    @recipes[recipe_index].make!
    update_csv
  end

  private

  def update_csv
    CSV.open(@csv_file_path, 'wb', { col_sep: ',' }) do |csv|
      @recipes.each { |recipe| csv << [recipe.name, recipe.description, recipe.prep_time, recipe.rating, recipe.done] }
    end
  end
end
