# frozen_string_literal: true

require 'http'
require 'json'

def create_states
  url = 'https://servicodados.ibge.gov.br/api/v1/localidades/estados'
  res = HTTP.get(url).body
  states = JSON.parse(res)

  states.each do |state|
    State.find_or_create_by(name: state['nome'], uf: state['sigla'])
  end
end
