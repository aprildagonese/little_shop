# README

## Little Shop
Little Shop of Hors d'Oeuvres is a group project developed as part of Backend Mod 2 at the Turing School of Software and Design. The assignment was to create a fictitious e-commerce platform where users could register to place items into a shopping cart and 'check out'. Merchant users needed to be able to mark items as 'fulfilled', and admin users could mark orders as 'complete'. Each user role needed to have access to some or all CRUD functionality for application models.

## Motivation
Mod 2 of the backend program trains students to build out web applications in Ruby. Specific goals of the Little Shop project included: advanced Rails routing, including nested resources and namespacing; advanced ActiveRecord usage; practice with HTML and CSS; use of session management; as well as authentication, authorization, and separation of user roles and permissions.

## Screenshots
Include logo/demo screenshot etc.

## Tech/framework used
<b>Built with</b>
- [Ruby on Rails](https://rubyonrails.org/)

## Installation
Little Shop of Hors d'Oeurves was built on Rails 5.1.6.1 and using PostgreSQL. It runs using 'bcrypt' for authentication. Please ensure that local environments are compatible before cloning down.

Installation Steps:
1. Fork and clone the repository at https://github.com/aprildagonese/little_shop
2. Run `bundle install`
3. Run `rake db:{create,migrate,seed}`
4. To run locally in development mode, run `rails s` in your terminal; then go to `localhost:3000` in your browser.

## Tests
All tests were built using RSpec and Capybara, with FactoryBot and Faker implemented for seed data.

To run the tests, simply clone down the repository and run the command: `rspec`

Tests are divided by models and features, with feature tests generally sub-divided by user view. Little Shop of Hors d'Oeuvres is proud to operate with 100% test coverage of all models, and we ask contributors to help us maintain this standard.

## How to use?
We provide demo accounts to help users explore the application. Please use the following accounts to log in. All accounts use the test password: `password`
- user@test.com
- merchant@test.com
- admin@test.com

## Contribute
To contribute to Little Shop of Hors D'Oeurves, please fork the repository at https://github.com/aprildagonese/little_shop and make a pull request back to the original repo.

## Credits
The developers of Little Shop of Hors d'Oeuvres would like to thank their instructors, Ian Douglas and Megan McMahon, for their help and support in the completion of the project. Everything we do, we do for you.
