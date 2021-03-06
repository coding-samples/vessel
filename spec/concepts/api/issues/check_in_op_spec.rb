require 'rails_helper'

RSpec.describe Api::Issues::CheckInOp do
  let(:regular) { User.create(login: 'test', password: '123456', name: 'Mr. Test') }
  let(:manager) { User.create(login: 'manager', password: '123456', name: 'Mr. Manager', role: :manager) }

  let(:issue) { Issue.create(title: 'test', author: regular) }

  describe 'permissions' do
    subject { described_class.allowed?(current_user, issue.id) }
    context 'i am a regular' do
      let(:current_user) { regular }
      it { expect(subject).to be_falsey }
    end
    context 'i am a manager' do
      let(:current_user) { manager }
      context 'it is unassigned issue' do
        it { expect(subject).to be_truthy }
      end
      context 'it is my issue' do
        let(:issue) { Issue.create(title: 'test', author: regular, manager: manager) }
        it { expect(subject).to be_truthy }
      end
      context 'it is not my issue' do
        let(:another_manager) { User.create(login: 'another_manager', password: '123456', name: 'Mr. Manager', role: :manager) }
        let(:issue) { Issue.create(title: 'test', author: regular, manager: another_manager) }
        it('be able to assign an issue to only yourself and only if it is not already assigned to somebody else') do
          expect(subject).to be_falsey
        end
      end
    end
  end

  describe 'business logic' do
    subject { described_class.execute(issue.id, manager) }
    it { expect(subject).to eq(issue) }
    it { expect(subject).to be_persisted }
    it('not be able to assign an issue to somebody else') { expect(subject.manager).to eq(manager) }
  end
end
