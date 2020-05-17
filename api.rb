require 'sinatra'
require 'sinatra/namespace'
require 'sinatra/reloader'
require 'mongoid'

Mongoid.load! "./config/mongoid.config"

set :port, 3001

namespace '/api/v1' do

  require './models/contato'
  require './models/contato_serializer.rb'
  require './helper/api_helper'

  before do
    content_type 'application/json'
  end

  # LIST ALL CONTATOS
  get '/contatos' do
    self.listar
  end

  # SHOW CONTATO DETAILS
  get '/contatos/:id' do
    contato = Contato.where(id: params[:id]).first
    halt 404, {message: "Contato não localizado"}.to_json unless contato
    ContatoSerializer.new(contato).to_json
  end

  # CREATE CONTATO
  post '/contatos' do
    request.body.rewind
    payload = JSON.parse request.body.read
    contato = Contato.new(payload)
    if contato.save
      response.header['Location'] = "http://localhost:4567/api/v1/contatos/#{contato.id}"
      ContatoSerializer.new(contato).to_json
    end
  end

  patch '/contatos/:id' do
    contato = Contato.where(id: params[:id]).first
    if contato.update_attributes(json_params)
      ContatoSerializer.new(contato).to_json
    else
      status 422
      body ContatoSerializer.new(contato).to_json
    end
    self.listar
  end

  # DELETE
  delete '/contatos/:id' do
    contato = Contato.where(id: params[:id]).first
    if contato
      contato.destroy
    else
    end
  end

  # TODO move this method to Contato model
  def listar
    contatos = Contato.all

    [:nome, :telefone].each do |filter|
      contatos = contatos.send(filter, params[filter]) if params[filter]
    end

    if contatos.present?
      contatos.map { |contato| ContatoSerializer.new(contato) }.to_json
    else
      {:message => 'Nenhum registro encontrado'}.to_json
    end
  end

end