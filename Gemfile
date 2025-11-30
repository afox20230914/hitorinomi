source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'rails', '~> 6.1.7', '>= 6.1.7.10'
gem 'puma', '~> 5.6'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  gem 'sqlite3', '~> 1.4'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  gem 'spring', '4.2.1'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver', '>= 4.0.0.rc1'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'bcrypt', '~> 3.1.7'
gem 'image_processing', '~> 1.2'
gem 'rails-i18n', '~> 6.0'
gem 'pg_search', '~> 2.3'
gem 'activeadmin', '~> 3.3'
gem 'pundit', '~> 2.5'
gem 'kaminari', '~> 1.2'
gem 'rack-attack', '~> 6.7'
gem 'paper_trail', '~> 16.0'
gem 'redis', '~> 5.4'
gem 'sidekiq', '~> 7.3'
gem 'mini_magick', '~> 5.3'
gem 'dotenv-rails'   # ← 重複削除済
gem 'net-smtp'
gem 'net-pop'
gem 'net-imap'

# 🔹 本番用 DB（RDS）
group :production do
  gem 'mysql2', '~> 0.5.5'
end
