require 'rubygems'
require 'sinatra'
require 'active_record'
require 'digest/md5'
require 'rack-flash'

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite",
  :database => "db/tms.sqlite"
)

class Mailbox < ActiveRecord::Base
end

class Domain < ActiveRecord::Base
  self.inheritance_column = :_type_disabled
end

class App < Sinatra::Application
end
  enable :sessions
  use Rack::Flash

  get '/' do
    redirect "/mss/", 303
  end

  get '/mss/' do
    @domains = Domain.all
    erb :domains
  end

  put '/mss/' do
    Domain.create(fqdn: params['fqdn'], type: 'local',
      description: params['description'] + ". " + (ENV['REMOTE_USER'] || ''),
      active: 1)
    flash[:notice] = "Domain #{params['fqdn']} created!"
    redirect "/mss/", 302
  end

  get '/mss/:domain/' do |n|
    @domain = Domain.find_by fqdn: n
    @mailboxes = Mailbox.where domain_id: @domain.id
    erb :domain
  end

  put '/mss/:domain/' do |n|
    domain = Domain.find_by fqdn: n
    sql = "select md5('#{params['password']}') from dual"
    pw = ActiveRecord::Base.connection.execute(sql).first.first
    mailbox = Mailbox.create(domain_id: domain.id, local_part: params['local_part'],
      password: pw,
      description: params['description'] + ". " + (ENV['REMOTE_USER'] || ''),
      active: 1)
    flash[:notice] = "Mailbox #{mailbox.local_part}@#{domain.fqdn} created!"
    redirect "/mss/#{domain.fqdn}/", 302
  end

  get '/mss/:domain/:local_part/' do 
    @domain = Domain.find_by fqdn: params['domain']
    @mailbox = Mailbox.find_by domain_id: @domain.id, local_part: params['local_part']
    erb :mailbox
  end

  delete '/mss/:domain/:local_part/' do 
    domain = Domain.find_by fqdn: params['domain']
    mailbox = Mailbox.find_by domain_id: domain.id, local_part: params['local_part']
    mailbox.delete
    flash[:notice] = "Mailbox #{mailbox.local_part}@#{domain.fqdn} deleted!"
    redirect "/mss/#{domain.fqdn}/", 302  
  end

  get '/mss/:domain/:local_part/verify-password/' do 
    domain = Domain.find_by fqdn: params['domain']
    mailbox = Mailbox.find_by domain_id: domain.id, local_part: params['local_part']
    sql = "select md5('#{params['password']}') from dual"
    pw = ActiveRecord::Base.connection.execute(sql).first.first
    if pw == mailbox.password
      flash[:notice] = "Verified! Password is correct."      
    else
      flash[:notice] = "<font color=\"red\">Password is not correct!</font>"           
    end    
    redirect "/mss/#{params['domain']}/#{params['local_part']}/", 302
  end  





