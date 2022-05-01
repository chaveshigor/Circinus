# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Picture, type: :model do
  describe 'Assossiations' do
    it { should belong_to(:profile) }
  end

  describe "Validations" do
    it { should validate_presence_of(:position) }
    it { should validate_presence_of(:storage_service_key) }
  end
end
