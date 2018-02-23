# README

This is a demo application showing my ability to write code in ruby. It pretends to be production-ready, 
but it doesn't implements any sophisticated features.

## Prerequisites
* postgresql 9.6+
* ruby 2.5
* gem bundler


## To deploy application locally do
```
./bin/setup
```

## To run application locally do
```
./bin/rails s
```

## Tests 
```
rspec spec
```


## How to use

There are couple examples how to use api. Use response from the LOGIN step as AUTH_TOKEN  

As Regular
```
LOGIN: curl -d '{"login":"regular", "password":"123456"}' -H "Content-Type: application/json" -X POST http://localhost:3000/api/users/sign_in
CREATE ISSUE: curl -d '{"title":"123"}' -H "Content-Type: application/json" -H "Authorization: AUTH_TOKEN" -X POST http://localhost:3000/api/issues
```

As Manager
```
LOGIN: curl -d '{"login":"manager", "password":"123456"}' -H "Content-Type: application/json" -X POST http://localhost:3000/api/users/sign_in
ASSIGN ISSUE: curl -d -H "Content-Type: application/json" -H "Authorization: AUTH_TOKEN" -X POST http://localhost:3000/api/issues/1/check_in
```

More endpoints for manager 
```
/api/issues/:id/check_in - assign issue to myself
/api/issues/:id/check_out - unassign issue to myself
/api/issues/:id/update_status - update_status
``` 
