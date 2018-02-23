require 'rails_helper'

RSpec.describe Api::Issues::CreateOp do
  let(:regular) { User.create(login: 'test', password: '123456', name: 'Mr. Test') }
  let(:manager) { User.create(login: 'manager', password: '123456', name: 'Mr. Manager', role: :manager) }

  describe 'permissions' do
    subject { described_class.allowed?(current_user) }
    context 'i am a regular' do
      let(:current_user) { regular }
      it { expect(subject).to be_truthy }
    end
    context 'i am a manager' do
      let(:current_user) { manager }
      it { expect(subject).to be_falsey }
    end
  end

  describe 'business logic' do
    subject { described_class.execute(regular, title: 'TEST', manager_id: manager.id, status: :in_progress) }
    it { expect(subject).to be_persisted }
    it { expect(subject.author).to eq(regular) }
    it { expect(subject.title).to eq('TEST') }
    it('not be able to update the status of your issues') { expect(subject).to be_pending }
    it('not be able to update the assigned manager of your issues') { expect(subject.manager).to be_nil }
  end
end
