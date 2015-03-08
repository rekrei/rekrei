source 'https://rubygems.org'
ruby '2.1.5'
#ruby-gemset=projectmosul
# Standard Rails gems
gem 'rails', '4.2.0'
gem 'sass-rails', '5.0.1'
gem 'uglifier', '2.6.0'
gem 'coffee-rails', '4.1.0'
gem 'jquery-rails', '4.0.3'
gem 'turbolinks', '2.5.3'
gem 'jbuilder', '2.2.6'
gem 'bcrypt', '3.1.9'

# Necessary for Windows OS (won't install on *nix systems)
gem 'tzinfo-data', platforms: [:mingw, :mswin]

# Kaminari: https://github.com/amatsuda/kaminari
gem 'kaminari', '0.16.2'

# Friendly_id: https://github.com/norman/friendly_id
gem 'friendly_id', '5.1.0'

# Font-awesome: https://github.com/FortAwesome/font-awesome-sass
gem 'font-awesome-sass', '4.2.2'

# Bootstrap 3: https://github.com/twbs/bootstrap-sass
gem 'bootstrap-sass', '3.3.3'
gem 'rmagick'
gem "paperclip", "~> 4.2"
gem 'paper_trail', '~> 4.0.0.beta'
gem 'dropzonejs-rails'

#for now, until we decide if we want to use this in production or not
gem 'sqlite3', '1.3.10'
gem 'dotenv-rails'

group :production do
  gem 'passenger'
end

group :development, :test do
  gem 'capistrano', '~> 3.3.0'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-passenger'
  gem 'capistrano-maintenance', github: "capistrano/maintenance", require: false 
  gem 'byebug', '3.5.1'
  gem 'web-console', '2.0.0'

  # Figaro: https://github.com/laserlemon/figaro
  gem 'figaro', '1.0.0'

  # Spring: https://github.com/rails/spring
  gem 'spring', '1.2.0'
  gem 'rspec-rails', '~> 3.0'
  gem 'shoulda-matchers'
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'guard-bundler', require: false
  gem 'guard-migrate', require: false
  gem 'capybara'
  gem 'fuubar'
end


# SQLite 3
group :development, :test do
end

# Devise: https://github.com/plataformatec/devise
gem 'devise', '3.4.1'

group :test do
  gem 'rspec-given'
end
