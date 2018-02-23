shared_examples 'it required auth' do
  context 'when unauthorized' do
    before { dispatch }

    it { expect(response.status).to eq(401) }
  end
  context 'when authorized as regular' do
    let!(:user) { User.create(login: 'regular', password: '123456', name: 'Mr. Regular') }
    let!(:auth_token) { Auth.authenticate('regular', '123456') }

    before { dispatch(headers: { "Authorization" => "Bearer #{auth_token}" }) }

    it { expect(response.status).to_not eq(401) }
  end
end
