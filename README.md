# Waste Carriers Front Office

![Build Status](https://github.com/DEFRA/waste-carriers-front-office/workflows/CI/badge.svg?branch=main)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=DEFRA_waste-carriers-front-office&metric=sqale_rating)](https://sonarcloud.io/dashboard?id=DEFRA_waste-carriers-front-office)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=DEFRA_waste-carriers-front-office&metric=coverage)](https://sonarcloud.io/dashboard?id=DEFRA_waste-carriers-front-office)
[![Licence](https://img.shields.io/badge/Licence-OGLv3-blue.svg)](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3)

The 'Register or renew as a waste carrier' service allows businesses, who deal with waste and have to register according to the regulations, to register online. Once registered, businesses can sign in again to edit their registrations if needed.

This project is the front office application which members of the public to renew a registration. It uses the [waste carriers engine](https://github.com/DEFRA/waste-carriers-engine).

## Prequisites

You'll need [Ruby 2.7.1](https://www.ruby-lang.org/en/) installed plus the [Bundler](http://bundler.io/) gem.

## Installation

First clone the repository and then drop into your new local repo

```bash
git clone https://github.com/defra/waste-carriers-front-office.git && cd waste-carriers-front-office
```

Next download and install the dependencies

```bash
bundle install
```

## Running locally

A [Vagrant](https://www.vagrantup.com/) instance has been created allowing easy setup of the waste carriers service. It includes installing all applications, databases and dependencies. This is located within GitLab (speak to the Ruby team).

Download the Vagrant project and create the VM using the instructions in its README. It includes installing and running a version of the waste-carriers-front-office app.

However, if you intend to work with the app locally (as opposed to on the Vagrant instance) and just use the box for dependencies, you'll need to:

- Log in into the Vagrant instance
- Using `ps ax`, identify the pid of the running waste-carriers-front-office app
- Kill it using `kill [pid id]`
- Exit the vagrant instance

Once you've created a `.env` file (see below) you should be ready to work with and run the project locally.

## Configuration

Any configuration is expected to be driven by environment variables when the service is run in production as per [12 factor app](https://12factor.net/config).

However when running locally in development mode or in test it makes use of the [Dotenv](https://github.com/bkeepers/dotenv) gem. This is a shim that will load values stored in a `.env` file into the environment which the service will then pick up as though they were there all along.

Check out [.env.example](/.env.example) for details of what you need in your `.env` file, and what environment variables you'll need in production.

## Databases

If you are running the waste carriers Vagrant VM, you have nothing to do! All databases are already created and the appropriate ports opened for access from the host to the VM.

If you intend to run it standalone, you'll need to create databases for the develop and test environments. There are 2 separate MongoDb databases for registration data and user data, so you'll need to create 4 databases in total. Multiple applications for the service use these databases, including this one.

### Seed data

The renewals process relies on users being created as part of waste-carriers-frontend. You should not be able to create a new user as part of a renewal.

However, you can seed the database with a test user so you can log in and access the features (this won't work in production).

The seed script also creates registrations to test the renewals process with.

Seed the databases with:

```bash
bundle exec rake db:seed
```

### Bulk seed data

It is occasionally necessary to generate large volumes of registration data in development for performance profiling or debugging purposes. This can be done using the `seeds:bulk_registrations` task. This takes the same source data as the regular seed task as a baseline and creates multiple registrations and transient_registrations for each of the seed items. Execute this with:

```bash
bundle exec rake seeds:bulk_registrations[registration_multiplier,transient_registration_multiplier]
```

where `registration_multiplier` is the number of registrations to create for each base seed registration and `transient_registration_multiplier` is the number of transient_registrations to create for each base seed registration. There are currently 38 base registrations in the seed data, so the following would generate 760 registrations and 380 transient_registrations:

```bash
bundle exec rake seeds:bulk_registrations[20,10]
```

Notes:
* This is not very efficient. Generating a production-scale (ca. 550,000 registrations) dataset takes in the region of 24 hours. 
* Rebuilding wcr-vagrant or otherwise resetting your development database will destroy this data. Taking a backup (using `mongodump`) is strongly recommended so that the generated data can easily be reloaded (using `mongorestore`) if needed in the future without having to run the bulk generation process again.

## Running the app

Simply start the app using `bundle exec rails s`. If you are in an environment with other Rails apps running you might find the default port of 3000 is in use and so get an error.

If that's the case use `bundle exec rails s -p 8001` swapping `8001` for whatever port you want to use.

## Testing the app

The test suite is written in RSpec.

To run all the tests, use `bundle exec rspec`

## Debugging

Add breakpoints with `byebug` and run `./bin/byebug` from *within your vagrant box* to start a session.

## Contributing to this project

If you have an idea you'd like to contribute please log an issue.

All contributions should be submitted via a pull request.

## License

THIS INFORMATION IS LICENSED UNDER THE CONDITIONS OF THE OPEN GOVERNMENT LICENCE found at:

http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3

The following attribution statement MUST be cited in your products and applications when using this information.

> Contains public sector information licensed under the Open Government license v3

### About the license

The Open Government Licence (OGL) was developed by the Controller of Her Majesty's Stationery Office (HMSO) to enable information providers in the public sector to license the use and re-use of their information under a common open licence.

It is designed to encourage use and re-use of information freely and flexibly, with only a few conditions.
