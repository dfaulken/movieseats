# movieseats

A Rails 6 app that implements the technical exercise by allowing users to create venues, view and edit available seats, view the resulting input JSON, specify the desired seat group size, and view the solution output JSON.

The core solution itself takes the form of [a Ruby class](/app/helpers/movie_seats_solver.rb) that could be extracted from the Rails app and used independently.

The Rails app has the following features:

+ PostgreSQL backend
+ HAML frontend
+ Small [jQuery component](/app/javascript/packs/testSolution.js) to handle submitting solution input and displaying solution output via AJAX
+ Complete [model](/spec/models), [helper](/spec/helpers), and [feature](/spec/features) testing written in RSpec with Capybara and FactoryBot

Other skills which I have aimed to demonstrate in this project:

+ GitHub [issue tracking](https://github.com/dfaulken/movieseats/issues) and [project management](https://github.com/dfaulken/movieseats/projects/1)
+ [In-code documentation](https://github.com/dfaulken/movieseats/blob/8e2b2f69333cbf3e80b7cd4f567eae66860442bc/app/helpers/movie_seats_solver.rb#L45-L48) of low-level design decisions
+ [Out-of-code documentation](#design) of high-level design decisions
## Dependencies

1. Ruby >2.3 (the newest Ruby feature that I believe I use is the safe navigation operator `&.`)
1. Bundler gem installed in your Ruby version of choice
1. PostgreSQL server
1. Node.js (for npm)
1. Chromedriver (for JS-dependent feature specs)

## Installation

Install the required Ruby gems:
```
$ bundle install
```

Customize the `config/database.yml` file with the credentials to your development and test PostgreSQL servers.

Initialize your development and test databases with:
```
$ bundle exec rails db:create db:schema:load
$ bundle exec rails db:schema:load RAILS_ENV=test
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
  + Or, quickly create a few sample venues with seat groups of various sizes free with `bundle exec rails db:seed`.
1. Go to 'Test Solution' for a venue. This shows the JSON data that will be input to the standalone solution class.
1. Click 'Test Solution'. This will send that JSON data to the solution class via a dedicated controller method. The solution class's output will be displayed as-is in the lower text area.

## Testing

Run the full test suite with:

```
$ bundle exec rspec
```

See [RSpec documentation](https://rspec.info/) for more detailed description of capabilities.

## Design

+ Two models, `Venue` and `Seat`, represent the basic entities. Basic validation and dependent-object handling is all that this use case calls for.
+ I did consider that this might be a good use case for a NoSQL database, primarily because individual seats store a tiny amount of data, but there could be a lot of them. Relational lookup of all seats for a specific venue is *okay*, but being able to retrieve and return a single data structure would be nice.

  In the end, because my professional experience has been entirely with relational databases, I chose not to go that route, since the purpose of this project was to demonstrate the capabilities that I *do* have. However, if I were implementing this as a side project for fun, I would almost certainly go the NoSQL route.
+ Venues are handled via CRUD, whereas seats (once initialized) are just fancy booleans, so a single API endpoint handles toggling their status.
+ Since I am more of a middle- and back-end developer by trade, I chose to focus my effort on those areas. The frontend is meant to be sufficient to show the functionality of the rest of the application, but nothing more than that.
+ The algorithm itself ultimately relies on calculating the distance between individual seats and the ideal front-and-center point. I chose this approach because in the real world, not all concert venues are laid out into perfect rows and columns. The approach could be easily adapted to accommodate a coordinates-based approach for representing more complicated seat layouts.
+ I spent about as much time implementing the tests as I did implementing the solution. It is definitely possible to go into more detail testing edge and corner cases. However, even these few tests (less than 40 examples total) were enough to catch out a simple error that I made early in the implementation, so I think they are also enough to demonstrate basic testing best practices.

### What does this app *not* do?

+ See the issues page for my documentation of the things that it occurred to me during development might be some nice-to-haves.
+ Other than the scalability concern of the relational backend discussed above, there is obviously a scaling risk for the frontend (many, many checkboxes), and the algorithm itself could be optimized as well (I commented in the code about this). However the algorithm is the main task at hand, and should be relatively efficient for real-world-sized audience-holding venues where a customer might want to be close to the front (on order of 100,000 seats).
+ I tested a 360x360 venue where every seat is available and the requested group size is 1, which is on the order of the worst real-world case (the Narendra Modi stadium in Ahmedabad, Gujarat, India has a seating capacity of 132,000). The performance running locally on my laptop was as follows:
  + Creation PUT request response time: 3902 ms (ActiveRecord: 843.5 ms)
  + Algorithm solve request response time: 2307 ms (most of which was just the data structure being transmitted back and forth)

  So the overall algorithm should be efficient enough for the use case.