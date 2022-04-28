# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Match, type: :model do
  describe 'Assossiations' do
    it { should belong_to(:profile_1) }
    it { should belong_to(:profile_2) }
  end
end
