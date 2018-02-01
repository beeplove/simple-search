# Simple Search

### What is this?
I started this project 'Simple Search' as a coding exercise for a role I was interviewing.
Simple Search uses three json files as data source and allows to find by word that is a value of any property and returns top level properties that matches.


### Components
Simple Search has two applications:
1. Service (rails-api using Rails 5.1)
2. Web UI (SPA built with Angular 5)

### How to run 'Service'?
To run Service simple run `rails s` after `bundle install`. Service will start on port 3000 and can be accessed at `http://localhost:3000`. Following endpoints are avaiable:
1. `/entities`
  for a list of entites available
2. `/entities/:id/fields` 
  for a list of fields available for a given entity, example: /entities/1/fields
3. `/search`
  to perform a search, available params are q  for query (required), e for entity name (optional), f for field name (optioinal). Example: /search?q=jordan or /search?q=jordan&e=organizations

### How to run 'Web UI'
To run Web UI, change directory to `web-ui`, and run `ng serve`, then visit `http://localhost:4200` on a browser.
