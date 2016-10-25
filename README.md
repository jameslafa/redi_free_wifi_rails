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
