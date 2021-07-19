# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path(__dir__)
end
require_relative 'cookbook'
require_relative 'recipe'
require_relative 'service'
# require_relative '../lib/view'
csv_file = File.join(__dir__, 'recipes.csv')
cookbook = Cookbook.new(csv_file)

get '/' do
  @recettes = cookbook.all
  erb :index, layout: :layout
end

get '/create' do
  erb :create, layout: :layout
end

get '/delete/:index' do
  cookbook.remove_recipe(params[:index].to_i)
  redirect to '/'
end

get '/recipe/:recipe/:index' do
  @recet = params[:recipe]
  @index = params[:index].to_i
  @recettes = cookbook.all
  erb :recipe
end

post '/store' do
  recipe = Recipe.new(params[:name], params[:description], params[:prep_time], params[:rating])
  cookbook.add_recipe(recipe)
  redirect to '/'
end

get '/websiteadd' do
  erb :websiteadd
end

post '/showwebsite' do
  scrape = ScrapeAllrecipesService.new(params[:ingredient])
  @website_recipes = scrape.call
  erb :showwebsite
end

post '/storewebsite' do
  array_strings = params[:value].split(';')
  recipe = Recipe.new(array_strings[0], array_strings[1], array_strings[2], array_strings[3])
  cookbook.add_recipe(recipe)
  redirect to '/'
end

get '/markasdone/:index' do
  @test = params[:index].to_i
  cookbook.update_recipe(@test)
  redirect to '/'
end
