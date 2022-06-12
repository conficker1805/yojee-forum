require 'rails_helper'

describe Post, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to :topic }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_length_of(:content).is_at_most(10_000) }
  end
end
