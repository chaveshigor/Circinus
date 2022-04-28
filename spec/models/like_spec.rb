# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'Assossiations' do
    it { should belong_to(:profile_sender) }
    it { should belong_to(:profile_receiver) }
  end
end
