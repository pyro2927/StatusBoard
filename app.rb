
require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'gravatar-ultimate'
require 'pry'

# setup datamapper
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/dev.db")

class StatusUpdate
  include DataMapper::Resource
  property :id,         Serial
  property :user,       String
  property :body,       Text
end

# finish datamapper
DataMapper.finalize
DataMapper.auto_upgrade!

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
  enable :sessions
end

get '/' do
  @updates = StatusUpdate.all
  erb :index
end

post '/update' do
  hash = JSON.parse(self.request.body.read)
  update = StatusUpdate.new
  update.user = hash["user"]
  update.body = hash["body"]
  update.save
end