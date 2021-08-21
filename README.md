# movieseats

A Rails 6 app that implements the technical exercise by allowing users to create venues, view and edit available seats, view the resulting input JSON, specify the desired seat group size, and view the solution output JSON.

The core solution itself takes the form of a Ruby class that could be extracted from the Rails app and used independently.

The Rails app has the following features:

+ PostgreSQL backend
+ HAML frontend
+ Small [jQuery component](/blob/main/app/javascript/packs/testSolution.js) to handle submitting solution input and displaying solution output via AJAX
+ Complete model, helper, and feature testing written in RSpec with Capybara and FactoryBot

Other skills which I have aimed to demonstrate in this project:

+ GitHub issue tracking and project management
+ In-code documentation of low-level design decisions
+ Out-of-code documentation of high-level design decisions

## Dependencies

1. Ruby >2.3 (the newest Ruby feature that I believe I use is the safe navigation operator `&.`)
1. Bundler gem installed in your Ruby version of choice
1. PostgreSQL server
1. Chromedriver (for JS-dependent feature specs)

## Installation

Install the required Ruby gems:
```
$ bundle install

```

Customize the `config/database.yml` file with the credentials to your development PostgreSQL server.

Initialize your development database with:
```
$ bundle exec rails db:create db:migrate

```

## Usage

Start a Rails server with:
```
$ bundle exec rails server

```

Then navigate to `localhost:3000`.

Recommended testing steps include:

1. Create a venue with a non-trivial number of rows and columns.
1. View that venue and check boxes next to the seats to mark them as available. Seats are unavailable by default.
1. Go to 'Test Solution' for a venue. This shows the JSON data that will be input to the standalone solution class.
1. Click 'Test Solution'. This will send that JSON data to the solution class via a dedicated controller method. The solution class's output will be displayed as-is in the lower text area.

## Testing

Initialize the testing database with:

```
$ bundle exec rails db:create db:migrate RAILS_ENV=test
```

Then run the full test suite with:

```
$ bundle exec rspec
```

See RSpec documentation for more detailed description of capabilities.