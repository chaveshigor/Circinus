# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Picture, type: :model do
  describe 'Assossiations' do
    it { should belong_to(:profile) }
  end
end
