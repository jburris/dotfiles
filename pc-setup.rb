#!/usr/bin/env ruby

# Assumes the following programs have been installed and configured: homebrew & git
# Also assumes you've checked out the dotfiles repository :)
#TODO: Override symlinks
#TODO: Check for existing configurations
#TODO: Ask if user wants to autoload

home = File.expand_path "~"
dot_folder = home + "/.dotfiles"

# symlink all dotfiles in folder
Dir.chdir "#{dot_folder}/dotfiles"

files = Dir.entries(Dir.pwd)
files.delete_if {|file_name| file_name.match(/\.{1,2}$/) }

puts "Symlinking dotfiles"
files.each { |file|  system "ln -s #{dot_folder}/dotfiles/#{file} #{home}/#{file}" }

# Install system packages with brew
puts "Installing brewdle"
system "gem install brewdle"

puts "Installing homebrew packages"
system "brewdle install"

# Use ZSH as primary shell
system "chsh -s /usr/local/bin/zsh jburris"

# Install default ruby
system "rbenv install `cat .rbenv-version`"

#### Package specific configurations (auto-launch, user creation, etc) ####

system "mkdir -p ~/Library/LaunchAgents"

#memcached
puts "Start memcached on login"
system "cp /usr/local/Cellar/memcached/1.4.13/homebrew.mxcl.memcached.plist ~/Library/LaunchAgents/"
system "launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.memcached.plist"

#mongodb
puts "Start mongodb on login"
system "cp /usr/local/Cellar/mongodb/2.0.4-x86_64/homebrew.mxcl.mongodb.plist ~/Library/LaunchAgents/"
system "launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist"

#mysql
puts "Installing initial mysql db"
system "unset TMPDIR"
system %{mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp}

puts "Start mysql on login"
system "cp /usr/local/Cellar/mysql/5.5.20/homebrew.mxcl.mysql.plist ~/Library/LaunchAgents/"
system "launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"

puts "NOTE : To run ruby versions older than 1.9.2 you need to install GCC as OS X no longer comes with it"
puts "Download it here : https://github.com/kennethreitz/osx-gcc-installer"

puts "Afterward, install ruby : rbenv install `cat ~/.rbenv-version`"
