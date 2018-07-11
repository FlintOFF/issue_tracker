require 'rails_helper'

RSpec.describe Manager, type: :model do
  it { should have_many(:issues) }

  it 'has a valid factory' do
    expect(create(:manager)).to be_valid
  end

  describe 'validations' do
    subject { create(:manager) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password_digest) }
  end
end
