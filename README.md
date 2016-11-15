# Learn how to build an Android Application and a Rails backend

**Project for [REDI School Berlin](http://redi-school.org)**

## Lesson 1 - Create your first Rails backend

### 1. Create new rails project

In your shell, go in the repository where you store all your dev project. The following command will create a new directory.

We will use PostgreSQL as a database because it's a default database used on [Heroku](https://www.heroku.com/).

````bash
# Create the new project with the command rails
rails new redi_free_wifi_rails -d postgresql

# Go in the new directory created
cd redi_free_wifi_rails

# See the new created files
ls -l
````

### 2. Commit your code on Github

You will save your code on Github. There your code is safe and you can share it with anyone.

 - Create a new Repository on [Github](https://github.com): [https://github.com/new](https://github.com/new)
 - Define a repository name `redi_free_wifi_rails` and click on `Create repository`
 - Go back to your shell and write the following commands

 ````bash
 echo "# redi_free_wifi_rails" >> README.md
 git init
 git add .
 git commit -m "Initialize my first Rails application"
 # /!\ Be careful, you HAVE TO replace the command below with the url of you own repository /!\
 git remote add origin git@github.com:jameslafa/redi_free_wifi_rails.git
 git push -u origin master
 ````

### 3. Set Rspec as the default testing framework

Rspec is a testing framework. We will start building tests in the next lesson but it's important to set it from the beginning of the project.

Of the name named `Gemfile` and add the following line `gem 'rspec-rails', '~> 3.5'` in the block `:development, :test`.

It should look like this:

````
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  # Use rspec as a testing framework
  gem 'rspec-rails', '~> 3.5'
end
````

After saving the file, go back to your shell.

````bash
# Add the new Gem (package for ruby development)
bundle install

# Initialize Rspec
rspec:install

# Check you have the new directory spec created
ls -l

# Delete the unnecessary folder test
rm -rf test
````

As soon as we made a significant change, we commit a new version of the code. In case something goes bad, we can always easily go back at this specific point.

````bash
git add .
git commit -m 'Install Rspec'
git push
````

### 4. Create a database user (unnecessary under OSX)

This is for linux users only. On Mac OSX the database does not require authentication locally.

We need to create a database user and setup the credentials in our rails application.

In your shell, execute the following commands:

````bash
# Change to the postgres user. It requires the root password. If you use the Vagrant image we created for you, it's redischool.
su - postgres

# Create the new database user
create role redi_free_wifi_rails with createdb login password 'redi_free_wifi_rails';
````

We now need to set our database user credentials in rails.

Edit the file `config/database.yml`

Edit the `development` and `test` configuration as described below:

````yaml
development:
  adapter: postgresql
  encoding: unicode
  database: redi_free_wifi_development
  pool: 5
  username: redi_free_wifi_rails
  password: redi_free_wifi_rails

test:
  adapter: postgresql
  encoding: unicode
  database: redi_free_wifi_test
  pool: 5
  username: redi_free_wifi_rails
  password: redi_free_wifi_rails
````

### 5. Create a venue scaffold

Our application with be the backend of an Android application which will display a list of venues offering free wifi. It could be bars, restaurants, co-working places, etc.

A venue will have the following attributes:
  - name
  - description
  - category (bar, restaurant, co-working space)
  - latitude (geo-coordinates)
  - longitude (geo-coordinates)

Our Android application will be able to list the venues around us, create new one, edit existing one and later search for venues.

We're going to create a Scaffold which will automatically create everything that we need to do that. Later we'll learn out to create all this manually.

Go back to your shell and execute the following command.
````bash
rails generate scaffold Venue name:string description:text category:integer latitude:float longitude:float
````

This is creating many files, we're going to learn together what are they used for.

````
create    db/migrate/20161025070502_create_venues.rb
create    app/models/venue.rb
invoke    rspec
create      spec/models/venue_spec.rb
invoke  resource_route
 route    resources :venues
invoke  scaffold_controller
create    app/controllers/venues_controller.rb
invoke    erb
create      app/views/venues
create      app/views/venues/index.html.erb
create      app/views/venues/edit.html.erb
create      app/views/venues/show.html.erb
create      app/views/venues/new.html.erb
create      app/views/venues/_form.html.erb
invoke    rspec
create      spec/controllers/venues_controller_spec.rb
create      spec/views/venues/edit.html.erb_spec.rb
create      spec/views/venues/index.html.erb_spec.rb
create      spec/views/venues/new.html.erb_spec.rb
create      spec/views/venues/show.html.erb_spec.rb
create      spec/routing/venues_routing_spec.rb
invoke      rspec
create        spec/requests/venues_spec.rb
invoke    helper
create      app/helpers/venues_helper.rb
invoke      rspec
create        spec/helpers/venues_helper_spec.rb
invoke    jbuilder
create      app/views/venues/index.json.jbuilder
create      app/views/venues/show.json.jbuilder
create      app/views/venues/_venue.json.jbuilder
invoke  assets
invoke    coffee
create      app/assets/javascripts/venues.coffee
invoke    scss
create      app/assets/stylesheets/venues.scss
invoke  scss
create    app/assets/stylesheets/scaffolds.scss
````

````bash
# Create development and test database
rails db:create

# Create the new venues Table
rails db:migrate

# Run rails server
rails server
````

You can now open your browser on the following url [http://localhost:3000](http://localhost:3000). It should display a nice page showing *Yay! You’re on Rails!*.

Now even more interesting, we can go on [http://localhost:3000/venues](http://localhost:3000/venues) and start to list, create, edit and delete venues.

It's time to commit our code.

````bash
git add .
git commit -m 'Create a new Venue Scaffold'
git push
````

----

## Lesson 2 - Model and controllers improvements

If you navigate to [http://localhost:3000/venues](http://localhost:3000/venues), you can already create, edit and delete venues. However, there is many things to improve before considering it ready to by used as an API.

### 1 - Enum: define the venue category

As you may have noticed above, the venue's category is saved as an integer.

Let's consider we have 3 different categories: bar, restaurant and co-working space. We could save the category in the database as a string: `"bar"`, `"restaurant"` or `"co-working space"`. It would work fine, however, it would take a lot more space than needed.

A very common solution is to save the category as an integer. We just have to tell our application that `1` means bar, `2` means restaurant, etc. and it will work perfectly.

Rails is using something call [Enum](http://edgeapi.rubyonrails.org/classes/ActiveRecord/Enum.html) to handle this very easily.

In our model Venue `app/models/venue.rb`, let's add the following.

````ruby
# Define category's Enum
enum category: {
  bar: 1,
  restaurant: 2,
  coworking_space: 3
}
````

From now on, rails will return a string with the right category even if it stores the value as an integer.

````ruby
venue = Venue.new(category: 1)
venue.category
=> "bar"
````

### 2 - Validate our model

It is very important to have consistent data in our database. For example if we are not sure that each venue has a name, how can we display them on a list? If not every venue has geo-coordinates, how can we display them on a map?

Rails has one of the best and easiest validation system out there. Your should start by reading this great guide [Active Record Validations](http://guides.rubyonrails.org/active_record_validations.html).

#### Required fields

We need to make sure that every venue has a name, a description and geo-coordinates (latitude + longitude). This means Rails will refuse to save inside a venue which does not have these attributes. Thanks to this system, we are certain that every venue stored in our database is valid.

To require this field, just one simple line needs to be added to our model Venue `app/models/venue.rb`.

````ruby
validates :name, :description, :latitude, :longitude, :presence => true
````

Let's try it out.

````ruby
venue = Venue.new
=> #<Venue id: nil, name: nil, description: nil, category: nil, latitude: nil, longitude: nil, created_at: nil, updated_at: nil>
venue.save
=> false
venue.errors.full_messages
=> ["Name can't be blank", "Description can't be blank", "Latitude can't be blank", "Longitude can't be blank"]
````

As we can see, `venue.save` returns `false` which means it has not been saved. In `venue.errors.full_messages` we can find which validation failed.

### 3 - Create a dataset for testing purposes

Rails has a very simple and easy system to build a dataset which will be shared by every developers on the project. Automatizing the creation of the dataset will save you a lot of time because it's something you will have to do quite regularly.

We will create new [Seeds](http://edgeguides.rubyonrails.org/active_record_migrations.html#migrations-and-seed-data). It's a simple ruby script creating new data in the database just by executing the command `rails db:seed`.

Let's edit the file `db/seeds.rb` and add the following lines:

````ruby
st_oberholz = Venue.create(name: 'St Oberholz', description: '2-story bar-restaurant, in a 19th-century building, with a daily changing menu, snacks & bagels. They have a great and free wifi connection.', category: 'bar', latitude: 52.5362144, longitude: 13.400969)
kaschk = Venue.create(name: 'Kaschk', description: 'Craft Beer, Shuffleboard & Coffee. Very fast and free internet connection. Password displayed behind the bar', category: 'bar', latitude: 52.5283261, longitude: 13.4077942)
````

Run `rails db:seed` to execute the script and create the venues. If you now navigate to [http://localhost:3000/venues](http://localhost:3000/venues) you will see the newly added venues.

#### 4 - Add an address to the model Venue

Rails make it very easy to add an attribute to a model. We do not have an address in our model Venue, so let's add one.

````bash
rails generate migration AddAddressToVenues address:string
````

As you can see in the console, a new file as been created: `db/migrate/20161102065451_add_address_to_venues.rb`. The number at the beginning of the file is the current timestamp so it will be different for you.

Let's see this file.

````ruby
class AddAddressToVenues < ActiveRecord::Migration[5.0]
  def change
    add_column :venues, :address, :string
  end
end
````

This migration applies a change in the database, it adds a column `address` of a type `string` in the table `venues`.

The modification is not yet applied to the database. To do so, execute the following command in your terminal:

````bash
rails db:migrate
````

Now the table venues has this new field. We can see it in the console.

````bash
rails console
````

````ruby
Venue.new
=> #<Venue id: nil, name: nil, description: nil, category: nil, latitude: nil, longitude: nil, created_at: nil, updated_at: nil, address: nil>
````

However, if we now go to the our views [http://localhost:3000/venues](http://localhost:3000/venues), we won't see the new field address. We need to add it manually.

#### 4 - Update views

Views are located in `app/views` directory. Our Venue resource views are located in `app/views/venues`.

````bash
_form.html.erb
_venue.json.jbuilder
edit.html.erb
index.html.erb
index.json.jbuilder
new.html.erb
show.html.erb
show.json.jbuilder
````

 - Files ending with `.html.erb` are html views generating the html pages you see when you navigate on [http://localhost:3000/venues](http://localhost:3000/venues) for example;
 - Files ending with `.json.jbuilder` are json views generating a json response. They will be used to build the API used by the Android application;
 - Files starting with `_` are partials. They are partial views which can be used in multiple views to avoid duplicating code.

##### Add the address field in the show view

In the file `app/views/venues/show.html.erb`, let's add the address field below the category.

````html
<p>
  <strong>Address:</strong>
  <%= @venue.address %>
</p>
````

Now if you navigate to [http://localhost:3000/venues/1](http://localhost:3000/venues/1), you will see the address.

##### Update the index view

In the file `app/views/venues/index.html.erb`, let's remove the description field and add the address instead.

````html
<thead>
  <tr>
    <th>Name</th>
    <th>Address</th>
    <th>Category</th>
    ....
  </tr>
</thead>
....
<% @venues.each do |venue| %>
  <tr>
    <td><%= venue.name %></td>
    <td><%= venue.address %></td>
    <td><%= venue.category %></td>
    ....
  </tr>
<% end %>
````

Now if you navigate to [http://localhost:3000/venues](http://localhost:3000/venues), you will see the address field instead of the description.

##### Update the JSON views

We are not using JSON views yet, however in the next chapter, they will be used to build the API for our Android application.

In the file `app/views/venues/_venue.json.jbuilder`, let's add the address field.

````ruby
json.extract! venue, :id, :name, :description, :category, :address, :latitude, :longitude, :created_at, :updated_at
````

Now if you navigate to [http://localhost:3000/venues/2.json](http://localhost:3000/venues/2.json), you will see the address field.

````json
{
  "id":2,
  "name":"St Oberholz",
  "description":"2-story bar-restaurant, in a 19th-century building, with a daily changing menu, snacks \u0026 bagels. They have a great and free wifi connection.",
  "category":"restaurant",
  "address":"Rosenthaler Str. 72A, 10437 Berlin",
  "latitude":52.5362144,
  "longitude":13.400969,
  "created_at":"2016-11-01T08:02:29.497Z",
  "updated_at":"2016-11-02T07:42:46.438Z",
  "url":"http://localhost:3000/venues/2.json"
}
````

##### Add field address in the form and update category
In the file `app/views/venues/_form.html.erb`, let's add the address field below the category.

````html
<div class="field">
  <%= f.label :address %>
  <%= f.text_field :address %>
</div>
````

Since we defined an Enum for the category, Rails expects a string and not an integer as a value. Let's replace the existing category field with the following to create a nice dropdown.

````html
<div class="field">
  <%= f.label :category %>
  <%= f.select :category, Venue.categories.keys.map { |w| [w.humanize, w] } %>
</div>
````

For security reasons, Rails whitelists the fields which can be updated from the views in the controller. To be able to update the address, we need to add it in the whitelist.

Let's edit our controller `app/controllers/venues_controller.rb` and add the address field in the function venue_params.

````ruby
def venue_params
  params.require(:venue).permit(:name, :description, :category, :address, :latitude, :longitude)
end
````

Now if you navigate to [http://localhost:3000/venues/1/edit](http://localhost:3000/venues/1/edit), you will be able to change the address.

## Lesson 3

### Authentication

#### Install devise

We want to restrict access to users we know. There is a very famous gem called [Devise](https://github.com/plataformatec/devise) that we'll help us build an authentication system.

Add the following gem in your Gemfile (outside of any group).

````ruby
gem 'devise'
````

and run

````bash
bundle install
rails generate devise:install
rails generate devise User
rake db:migrate
````

In the file `config/environment/development.rb` add the following line:

````ruby
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
````

Let's define a default route. This will tell our application which controller and action should be executed when the user navigate on `/`. By default we will show the venue list. Add the following line in `config/routes.rb`.

````ruby
root to: 'venues#index'
````

It tells Rails what is the default url running our server on development. It is used to generate urls sent by email like the reset password link.

Have a look at the last migration created in `db/migrate/XXX_devise_create_users.rb` to see the new table which has been created by devise. It will hold every information we need for the authentication.

If your server was running while doing this, please restart it.

#### Enable authentication using devise

We want to restrict access to the entire application. `app/controllers/application_controller.rb` is the parent controller. It means that by default, every controller inherits from this one and therefor any modification of this controller will be applied to any other controller. It is then the perfect place to add our access restriction code if we want it to be applied everywhere.

The only thing we need to do to require the user to be authenticated is to add the following line in `app/controllers/application_controller.rb`.

````ruby
before_action :authenticate_user!
````

Now if you navigation to [http://localhost:3000/venues](http://localhost:3000/venues) you'll be redirected to [http://localhost:3000/users/sign_in](http://localhost:3000/users/sign_in) to sign in first.

That's it, out application is now protected! Oh, even from us!

#### Registration

From now, a user account is need to access any page of the app. However, anyone can create an account going on [http://localhost:3000/users/sign_up](http://localhost:3000/users/sign_up). For many application, you want user to be able to create a new account but in our case, we do not want anybody to be able to create an account and modify our data.

What we're going to do is to let the application let us create only one user. When this user is created, it won't be able to create a new one. It will suit our specific need.

There is a simple tutorial for that: [https://github.com/plataformatec/devise/wiki/How-To:-Set-up-devise-as-a-single-user-system](https://github.com/plataformatec/devise/wiki/How-To:-Set-up-devise-as-a-single-user-system).

In `config/routes.rb`, we will Rails to use a new controller that we are about to create to handle registration.

````ruby
# Replace
devise_for :users
# by
devise_for :users, controllers: { registrations: "registrations"}
````

Now let's create the new controller. Create a new file `app/controllers/registrations_controller.rb` with the following content:

````ruby
class RegistrationsController < Devise::RegistrationsController

  before_action :one_user_registered?, only: [:new, :create]

  protected

  def one_user_registered?
    if ((User.count == 1) & (user_signed_in?))
      redirect_to root_path
    elsif User.count == 1
      redirect_to new_user_session_path
    end  
  end

end
````

Before create a new user, the method `one_user_registered?` is called. If there is already already a user in the database, he is redirected to the sign_in page. If he is already signed_in, it will be redirected to the default page of the app.

Now we can go to [http://localhost:3000/users/sign_up](http://localhost:3000/users/sign_up) and create our user account. After creating it, we should see our data again!

#### Log out
Now we are signed in, but how to we log out?

Let's look at our routes

````bash
rails routes
````

We can see the following route: `destroy_user_session DELETE /users/sign_out(.:format)      devise/sessions#destroy`.

It means we need to make a DELETE request on `/users/sign_out`. We want to be able to logout from any page, so we can add a button in our default layout.

Let's add the following lines in `app/views/layouts/application.html.erb`, above `<%= yield %>`

````html
<% if user_signed_in? %>
  <div class="nav">
    <%= link_to('Logout', destroy_user_session_path, :method => :delete) %>
  </div>
<% end %>
````

Now we have a logout link. Click on it and it will log you out.

Let's test that we are not able to create a new user anymore by going on [http://localhost:3000/users/sign_up](http://localhost:3000/users/sign_up). You should be automatically redirected to [http://localhost:3000/users/sign_in](http://localhost:3000/users/sign_in).

That's it, we have a simple authentication system protecting our data and that we can use from our API!

### Deploy on Heroku

Heroku is a serving where you can host and run your rails app for free. Create an account on [http://www.heroku.com](http://www.heroku.com) and follow this [instructions](https://devcenter.heroku.com/articles/git). With a few commands, your app will be running.

I already deployed a version of our application on [https://redi-free-wifi.herokuapp.com](https://redi-free-wifi.herokuapp.com/)
