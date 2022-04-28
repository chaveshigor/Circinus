# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HobbyCategory, type: :model do
  describe 'Assossiations' do
    it { should have_many(:hobbies) }
  end
end
