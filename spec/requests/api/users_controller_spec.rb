require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do

  describe 'sign_in' do
    let(:user) { User.create(login: 'regular', password: '123456', name: 'Mr. Regular') }
    subject { post :sign_in, login: 'test', password: '123456' }
  end

end
