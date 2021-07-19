require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end
require_relative 'cookbook'
require_relative 'recipe'
# require_relative '../lib/view'
csv_file = File.join(__dir__, 'recipes.csv')
cookbook = Cookbook.new(csv_file)

get '/' do
  @recettes = cookbook.all
  erb :index
end

get '/create' do
  erb :create
end

# get '/about' do
#   erb :about
# end

post '/about' do
  erb :about
end

get '/recipe/:recipe' do
puts params[:recipe]
"the recipe is #{params[:recipe]}"
end

post '/store' do
  recipe = Recipe.new(params[:name], params[:description], params[:prep_time], params[:rating])
  cookbook.add_recipe(recipe)
  redirect to '/'
  erb :store
end

# require_relative 'cookbook'    # You need to create this file!
# require_relative 'controller'  # You need to create this file!
# require_relative 'router'

# csv_file   = File.join(__dir__, 'recipes.csv')
# cookbook   = Cookbook.new(csv_file)
# controller = Controller.new(cookbook)

# router = Router.new(controller)

# # Start the app
# router.run
