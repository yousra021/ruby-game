require 'logger'
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
# The line `require "bootsnap/setup"` is loading the Bootsnap gem and setting it up to cache expensive
# operations in order to speed up the boot time of the application. Bootsnap is a library that helps
# optimize the performance of Ruby applications by caching and speeding up certain operations like
# loading and parsing files.
# require "bootsnap/setup" # Speed up boot time by caching expensive operations.
