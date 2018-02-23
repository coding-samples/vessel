require 'rails_helper'

RSpec.describe Api::Issues::UpdateOp do
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
    subject { described_class.execute(issue.id, title: 'TEST', manager_id: manager.id, status: :in_progress) }
    it { expect(subject).to be_persisted }
    it { expect(subject.title).to eq('TEST') }
    it('not be able to update the status of your issues') { expect(subject).to be_pending }
    it('not be able to update the assigned manager of your issues') { expect(subject.manager).to be_nil }
  end
end
