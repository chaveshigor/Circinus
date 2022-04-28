# frozen_string_literal: true

require 'rails_helper'

RSpec.describe State, type: :model do
  describe 'Assossiations' do
    it { should have_many(:cities) }
  end
end
