# README

This is my version of test task "issue_tracker". 
You can read full description for this task in the file [TASK.md](TASK.md).

## System dependencies
You must already have installed version of ruby **2.5.1** and gem **bundle**

## Install
```
git clone git@github.com:FlintOFF/issue_tracker.git
cd issue_tracker
./bin/setup
```

## Configuration
* Don't forget change secret key in file config/initializers/knock.rb in line `config.token_secret_signature_key = -> { 'secret' }`
* The system already have one manager (manager1@test.com:password), so don't forget to replace default password for this manager `Manager.first.update(password: 'new_password')` 

## Test
* For run all tests `rspec`
* For clients:
    - registration new client `curl -H "Content-Type: application/json" -d '{"email":"client1@test.com", "password":"password"}' -X POST http://localhost:3000/api/v1/clients/registrations`
    - create token `curl -H "Content-Type: application/json" -d '{"auth": {"email": "client1@test.com", "password": "password"}}' -X POST http://localhost:3000/api/v1/clients/tokens`
    - create issue `curl -H "Authorization: JWT _TOKEN_" -H "Content-Type: application/json" -d '{"title":"title", "body": "body"}' -X POST http://localhost:3000/api/v1/clients/issues` 
    - issues list `curl -H "Authorization: JWT _TOKEN_" http://localhost:3000/api/v1/clients/issues` 
* For managers:
    - create token for existing manager `curl -d '{"auth": {"email": "manager1@test.com", "password": "password"}}' -H "Content-Type: application/json" -X POST http://localhost:3000/api/v1/managers/tokens`
    - registration new manager `curl -H "Authorization: JWT _TOKEN_" -H "Content-Type: application/json" -d '{"email":"manager2@test.com", "password":"password"}' -X POST http://localhost:3000/api/v1/managers/registrations` 
    - issues list `curl -H "Authorization: JWT _TOKEN_" http://localhost:3000/api/v1/managers/issues`

## TODO
* Create model 'messages' for conversation between manager and client
* Docker


