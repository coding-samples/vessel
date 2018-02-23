require 'rails_helper'

RSpec.describe Api::Issues::DestroyOp do
  let(:regular) { User.create(login: 'test', password: '123456', name: 'Mr. Test') }
  let(:manager) { User.create(login: 'manager', password: '123456', name: 'Mr. Manager', role: :manager) }

  let(:issue) { Issue.create(title: 'test', author: regular) }

  describe 'permissions' do
    subject { described_class.allowed?(current_user, issue.id) }
    context 'i am a regular' do
      let(:current_user) { regular }
      context 'when it is my issue' do
        it { expect(subject).to be_truthy }
      end
      context 'when it is not my issue' do
        let(:another_regular) { User.create(login: 'another_regular', password: '123456', name: 'Mr. Test') }
        let(:issue) { Issue.create(title: 'test', author: another_regular) }
        it { expect(subject).to be_falsey }
      end
    end
    context 'i am a manager' do
      let(:current_user) { manager }
      it { expect(subject).to be_falsey }
    end
  end

  describe 'business logic' do
    subject { described_class.execute(issue.id) }
    it { expect(subject).to be_destroyed }
  end
end
