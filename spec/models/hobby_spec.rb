# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hobby, type: :model do
  describe 'Assossiations' do
    it { should belong_to(:hobby_category) }
    it { should have_many(:profile_hobbies) }
  end
end
