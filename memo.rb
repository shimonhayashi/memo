# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def get_saved_memo_path(id)
    "data/memos_#{id}.json"
  end

  def read_memo_json
    file_path = get_saved_memo_path(params[:id])
    File.exist?(file_path) ? (memos = File.open(file_path) { |file| JSON.parse(file.read) }) : (redirect to('not_found'))
    @title = memos['title']
    @content = memos['content']
    @id = memos['id']
  end
end

get '/' do
  redirect to('/memos')
end

get '/memos' do
  @memos = Dir.glob('data/*').map { |file| JSON.parse(File.open(file).read) }
  @memos = @memos.sort_by { |file| file['time'] }
  erb :index
end

post '/memos' do
  memos = { 'id' => SecureRandom.uuid, 'title' => params[:title], 'content' => params[:content], 'time' => Time.now }
  File.open("data/memos_#{memos['id']}.json", 'w') { |file| JSON.dump(memos, file) }
  redirect to("/memos/#{memos['id']}")
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  read_memo_json
  erb :detail
end

get '/memos/:id/edit' do
  read_memo_json
  erb :edit
end

patch '/memos/:id/edit' do
  file_path = get_saved_memo_path(params[:id])
  File.open(file_path, 'w') do |file|
    memos = { 'id' => params[:id], 'title' => params[:title], 'content' => params[:content], 'time' => Time.now }
    JSON.dump(memos, file)
  end
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  file_path = get_saved_memo_path(params[:id])
  File.delete(file_path)
  redirect to('/memos')
end

not_found do
  erb :not_found
end
