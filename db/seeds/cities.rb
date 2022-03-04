# frozen_string_literal: true

require 'http'
require 'json'

def create_cities
  states = State.all

  states.each do |state|
    url = "https://servicodados.ibge.gov.br/api/v1/localidades/estados/#{state.uf}/municipios"
    res = HTTP.get(url).body
    cities = JSON.parse(res)

    cities.each do |city|
      City.find_or_create_by(name: city['nome'], state_id: state.id)
    end
  end
end
