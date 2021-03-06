require 'rails_helper'

RSpec.describe Client, type: :model do
  subject { create(:client) }

  it { should have_many(:issues) }

  it 'has a valid factory' do
    expect(create(:client)).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password_digest) }
  end
end
