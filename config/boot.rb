# config/boot.rb  ←全文置換

require 'logger'            # ← これが無いと絶対にエラーになる
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup'     # Set up gems listed in the Gemfile.
require 'bootsnap/setup'    # Speed up boot time by caching expensive operations.
