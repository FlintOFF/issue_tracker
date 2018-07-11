require 'rails_helper'

RSpec.describe Issue, type: :model do
  context 'associations' do
    it { should belong_to(:client) }
    it { should belong_to(:manager) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end

  it { should define_enum_for(:status).with(pending: 0, in_progress: 5, resolved: 9) }
end
