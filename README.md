Requirements:

* [RVM](https://rvm.io/)

* [PostgreSQL](https://www.postgresql.org/)

* Ruby 2.7.2

Setup:

* bundle install

* `rake db:create && rake db:migrate`

* `rackup`

* `rake db:seed` to seed the db using requests

Testing:

```shell
RACK_ENV=test rake db:createrake
RACK_ENV=test rake db:migrate
bundle exec rspec
```
