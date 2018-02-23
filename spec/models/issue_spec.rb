require 'rails_helper'

RSpec.describe Issue do

  describe 'validate of status' do
    let(:regular) { User.create(login: 'test', password: '123456', name: 'Mr. Test') }
    let(:manager) { User.create(login: 'manager', password: '123456', name: 'Mr. Manager', role: :manager) }

    [:in_progress, :resolved].each do |new_status|
      subject { issue.update_attributes(status: new_status) }
      context 'when unassigned' do
        let(:issue) { Issue.create(title: 'test', author: regular) }
        it { expect(subject).to be_falsey }
      end
      context 'when assigned' do
        let(:issue) { Issue.create(title: 'test', author: regular, manager: manager ) }
        it { expect(subject).to be_truthy }
      end
    end
  end

end