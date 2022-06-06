require 'rails_helper'

describe Topic, type: :model do
  describe 'Associations' do
    it { is_expected.to have_many :posts }
    it { is_expected.to have_many :questions }
  end

  describe 'Validations' do
    it { is_expected.to validate_length_of(:title).is_at_least(1) }
    it { is_expected.to validate_length_of(:title).is_at_most(140) }
  end
end
