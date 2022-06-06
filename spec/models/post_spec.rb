require 'rails_helper'

describe Post, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to :topic }
  end
end
