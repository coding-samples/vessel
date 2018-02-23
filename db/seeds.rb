User.create(login: 'manager', password: '123456', name: 'Mr. Manager', role: :manager)

regular = User.create(login: 'regular', password: '123456', name: 'Mr. Regular')
Issue.create(title: 'Test', author: regular)
