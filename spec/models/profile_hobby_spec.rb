# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProfileHobby, type: :model do
  describe 'Assossiations' do
    it { should belong_to(:hobby) }
    it { should belong_to(:profile) }
  end
end
