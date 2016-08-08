#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db 
	db = SQLite3::Database.new 'lair.db'
	db.results_as_hash = true
	return db
end


before do
	
end

configure do 
	db = init_db

	db.execute 'CREATE  TABLE IF NOT EXISTS "posts" 
		(
		"id" INTEGER PRIMARY KEY  AUTOINCREMENT,
	 	"created_date" DATETIME,
	  	"content" TEXT
	  	)'
end

get '/' do
	db = init_db
	@results = db.execute 'select * from posts order by created_date desc'
	erb :index
end

get '/something' do
  erb "Hello World"
end

get '/lair' do
  erb :lair
end

get '/new' do
	erb :new
end

post '/new' do
	@post_text = params[:post_text]

	if @post_text.strip.empty?
		@error = 'Your whisper quiet. I did not hear' 
		return erb :new
	end

	db = init_db
	db.execute	'insert into posts (content,created_date) values (?, datetime())', [@post_text]
	
	redirect to '/' 
	erb "You typed #{@post_text}"
end

get '/details/:post_id' do
	post_id = params[:post_id]

	db = init_db
	results = db.execute 'select * from posts where id = ?',[post_id]
	@row = results[0]

	erb :details
end
