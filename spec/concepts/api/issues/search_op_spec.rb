require 'rails_helper'

RSpec.describe Api::Issues::SearchOp do
  let(:regular1) { User.create(login: 'test1', password: '123456', name: 'Mr. Test') }
  let(:regular2) { User.create(login: 'test2', password: '123456', name: 'Mr. Test') }
  let(:manager1) { User.create(login: 'manager1', password: '123456', name: 'Mr. Manager', role: :manager) }
  let(:manager2) { User.create(login: 'manager2', password: '123456', name: 'Mr. Manager', role: :manager) }

  let!(:issue1) { Issue.create(title: 'test', author: regular1) }
  let!(:issue2) { Issue.create(title: 'test', author: regular2) }
  let!(:issue3) { Issue.create(title: 'test', author: regular1, manager: manager1, status: :in_progress) }
  let!(:issue4) { Issue.create(title: 'test', author: regular2, manager: manager2, status: :resolved) }

  describe 'permissions' do
    subject { described_class.allowed?(current_user) }
    context 'i am a regular' do
      let(:current_user) { regular1 }
      it { expect(subject).to be_truthy }
    end
    context 'i am a manager' do
      let(:current_user) { manager1 }
      it { expect(subject).to be_truthy }
    end
  end

  describe 'business logic' do
    describe 'default scope' do
      subject { described_class.execute(current_user) }
      context 'i am a regular' do
        let(:current_user) { regular1 }
        it { expect(subject).to eq([issue3, issue1]) }
      end
      context 'i am a manager' do
        let(:current_user) { manager1 }
        it { expect(subject).to eq([issue4, issue3, issue2, issue1]) }
      end
    end

    describe 'filter by status' do
      subject { described_class.execute(manager1, status: status) }
      context 'when status pending' do
        let!(:status) { :pending }
        it { expect(subject).to eq([issue2, issue1]) }
      end
      context 'when status in progress' do
        let!(:status) { :in_progress }
        it { expect(subject).to eq([issue3]) }
      end
      context 'when status resolved' do
        let!(:status) { :resolved }
        it { expect(subject).to eq([issue4]) }
      end
    end

    describe 'pagination' do
      before { 9.times { Issue.create(title: 'test', author: regular1) } }
      subject { described_class.execute(manager1, page: page, per_page: 3) }
      context 'when first page' do
        let(:page) { 1 }
        it { expect(subject).to_not include([issue4, issue3, issue2, issue1]) }
      end
      context 'when page in the middle of range' do
        let(:page) { 4 }
        it { expect(subject).to eq([issue4, issue3, issue2]) }
      end
      context 'when last page with items' do
        let(:page) { 5 }
        it { expect(subject).to eq([issue1]) }
      end
      context 'when not existed page' do
        let(:page) { 9999 }
        it { expect(subject).to eq([]) }
      end
    end
  end
end
