#!/usr/bin/env ruby
# Assumes the following programs have been installed and configured: homebrew & git
# Also assumes you've checked out the dotfiles repository :)

home = File.expand_path "~"
dot_folder = home + "/.dotfiles"

# symlink all dotfiles in folder
Dir.chdir "#{dot_folder}/dotfiles"

files = Dir.entries(Dir.pwd)
files.delete_if {|file_name| file_name.match(/\.{1,2}$/) }

puts "Symlinking dotfiles"
files.each { |file|  system "ln -s #{dot_folder}/dotfiles/#{file} #{home}/#{file}" }

# Install system packages with brew
brew_packages = %w{ack bazaar git imagemagick memcached mongodb mysql node rbenv rbenv-gemset wget}

puts "Installing homebrew packages"
brew_packages.each do |package|
  puts "Installing : #{package}"
  system "brew install #{package}" 
end

###### Package specific configurations (auto-launch, user creation, etc)

system "mkdir -p ~/Library/LaunchAgents"

#memcached
system "cp /usr/local/Cellar/memcached/1.4.13/homebrew.mxcl.memcached.plist ~/Library/LaunchAgents/"
system "launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.memcached.plist"
