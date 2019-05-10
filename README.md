# Laradock Init

Simple bash script to clone and initialize project for local development using Docker with [laradock](https://github.com/laradock/laradock)

Put file in same folder as laradock and your other projects and run by executing ./laravel_install.sh

```
Code
├── laradock
├── ProjectA
├── ProjectB
└── laravel_install.sh
```

1. Clones repository
2. Creates apache config using repository name (directs to repo_name.test, you will have to set up /etc/hosts yourself)
3. Creates database using repository name
4. Runs composer install & yarn
5. Links storage
6. Creates .env file from env.example
7. Sets up app url & database variables in .env file
8. Generates application key
9. Asks if user wants to migrate database
10. Restarts apache container
11. Project should be up and running
