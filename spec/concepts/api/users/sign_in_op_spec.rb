require 'rails_helper'

RSpec.describe Api::Users::SignInOp do
  let(:user) { User.create(login: 'test', password: '123456', name: 'Mr. Test') }

  describe 'permissions' do
    subject { described_class.allowed? }
    it { expect(subject).to be_truthy }
  end

  describe 'business logic' do
    before { expect(Auth).to receive(:authenticate).and_return('qwerty') }
    subject { described_class.execute(user.login, '123456') }
    it { expect(subject).to eq('qwerty') }
  end
end
