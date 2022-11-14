# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def conn
  @conn ||= PG.connect(dbname: 'postgres')
end

configure do
  result = conn.exec("SELECT * FROM information_schema.tables WHERE table_name = 'memos'")
  conn.exec('CREATE TABLE memos (id serial, title varchar(255), content text, created timestamp default CURRENT_TIMESTAMP)') if result.values.empty?
end

def read_memos
  conn.exec('SELECT * FROM memos order by created DESC')
end

get '/' do
  redirect to('/memos')
end

get '/memos' do
  @memos = read_memos
  erb :index
end

def post_memo(title, content)
  conn.exec_params('INSERT INTO memos(title, content) VALUES ($1, $2);', [title, content])
end

post '/memos' do
  title = params[:title]
  content = params[:content]
  post_memo(title, content)
  redirect '/memos'
end

get '/memos/new' do
  erb :new
end

def read_memo(id)
  result = conn.exec_params('SELECT * FROM memos WHERE id = $1;', [id])
  result.tuple_values(0)
end

get '/memos/:id' do
  memo = read_memo(params[:id])
  @title = memo[1]
  @content = memo[2]
  erb :detail
end

get '/memos/:id/edit' do
  memo = read_memo(params[:id])
  @title = memo[1]
  @content = memo[2]
  erb :edit
end

def edit_memo(title, content, id)
  conn.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3;', [title, content, id])
end

patch '/memos/:id' do
  title = params[:title]
  content = params[:content]
  edit_memo(title, content, params[:id])
  redirect "/memos/#{params[:id]}"
end

def delete_memo(id)
  conn.exec_params('DELETE FROM memos WHERE id = $1;', [id])
end

delete '/memos/:id' do
  delete_memo(params[:id])
  redirect '/memos'
end

not_found do
  erb :not_found
end
