require 'rails_helper'

RSpec.describe Api::Issues::ChangeStatusOp do
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
        it { expect(subject).to be_falsey }
      end
      context 'it is my issue' do
        let(:issue) { Issue.create(title: 'test', author: regular, manager: manager) }
        it('be able to change the status of the issue only if the issue is assigned to you') do
          expect(subject).to be_truthy
        end
      end
      context 'it is not my issue' do
        let(:another_manager) { User.create(login: 'another_manager', password: '123456', name: 'Mr. Manager', role: :manager) }
        let(:issue) { Issue.create(title: 'test', author: regular, manager: another_manager) }
        it('not be able to change the status of an issue unless it is assigned to you') do
          expect(subject).to be_falsey
        end
      end
    end
  end

  describe 'business logic' do
    let(:issue) { Issue.create(title: 'test', author: regular, manager: manager, status: :in_progress) }
    subject { described_class.execute(issue.id, :resolved) }
    it { expect(subject).to eq(issue) }
    it { expect(subject).to be_persisted }
    it { expect(subject).to be_resolved }
  end
end
