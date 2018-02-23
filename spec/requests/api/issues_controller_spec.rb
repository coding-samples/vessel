require 'rails_helper'

RSpec.describe Api::IssuesController, type: :request do

  describe 'index' do
    def dispatch(options = {})
      get '/api/issues', headers: options[:headers]
    end

    it_behaves_like 'it required auth'
  end

  describe 'create' do
    def dispatch(options = {})
      post '/api/issues', params: { issue: { title: '1234' } }, headers: options[:headers]
    end

    it_behaves_like 'it required auth'
  end

  describe 'update' do
    let!(:user) { User.create(login: 'regular', password: '123456', name: 'Mr. Regular') }
    let!(:issue) { Issue.create(title: 'test', author: user) }

    def dispatch(options = {})
      put "/api/issues/#{issue.id}", params: { issue: { title: '1234' } }, headers: options[:headers]
    end

    it_behaves_like 'it required auth'
  end

  describe 'check_in' do
    let!(:regular) { User.create(login: 'regular', password: '123456', name: 'Mr. Regular') }
    let!(:issue) { Issue.create(title: 'test', author: regular) }
    let!(:user) { User.create(login: 'manager', password: '123456', name: 'Mr. Manager') }

    def dispatch(options = {})
      post "/api/issues/#{issue.id}/check_in", headers: options[:headers]
    end

    it_behaves_like 'it required auth'
  end

  describe 'check_out' do
    let!(:regular) { User.create(login: 'regular', password: '123456', name: 'Mr. Regular') }
    let!(:issue) { Issue.create(title: 'test', author: regular, manager: user) }
    let!(:user) { User.create(login: 'manager', password: '123456', name: 'Mr. Manager') }

    def dispatch(options = {})
      post "/api/issues/#{issue.id}/check_out", headers: options[:headers]
    end

    it_behaves_like 'it required auth'
  end

  describe 'update_status' do
    let!(:regular) { User.create(login: 'regular', password: '123456', name: 'Mr. Regular') }
    let!(:issue) { Issue.create(title: 'test', author: regular, manager: user) }
    let!(:user) { User.create(login: 'manager', password: '123456', name: 'Mr. Manager') }

    def dispatch(options = {})
      post "/api/issues/#{issue.id}/update_status", params: {status: :in_progress}, headers: options[:headers]
    end

    it_behaves_like 'it required auth'
  end

end
