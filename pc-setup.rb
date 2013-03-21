#!/usr/bin/env ruby
load 'common.rb'

start_dir = Dir.pwd
home = File.expand_path "~"
dot_folder = home + "/.dotfiles"

# Gems
puts info("Installing ruby gems from Gemfile")
system "gem install bundler"
system "bundle install"

# EMACS
# puts info("Emacs is a special snowflake -- Installing")
# Dir.chdir home
# system "git clone https://github.com/railwaycat/emacs-mac-port"
# Dir.chdir "#{home}/emacs-mac-port"
# system "build-emacs-app.sh"

#### Package specific configurations (auto-launch, user creation, etc) ####
system "mkdir -p ~/Library/LaunchAgents"

#memcached
puts info("Start memcached on login")
system "cp /usr/local/Cellar/memcached/1.4.13/homebrew.mxcl.memcached.plist ~/Library/LaunchAgents/"
system "launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.memcached.plist"

#mongodb
puts info("Start mongodb on login")
system "cp /usr/local/Cellar/mongodb/2.0.4-x86_64/homebrew.mxcl.mongodb.plist ~/Library/LaunchAgents/"
system "launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist"

#mysql
puts info("Installing initial mysql db")
system "unset TMPDIR"
system %{mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp}

puts info("Start mysql on login")
system "cp /usr/local/Cellar/mysql/5.5.20/homebrew.mxcl.mysql.plist ~/Library/LaunchAgents/"
system "launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"

puts notice("NOTE : To run ruby versions older than 1.9.2 you need to install GCC as OS X no longer comes with it")
puts notice("Download it here : https://github.com/kennethreitz/osx-gcc-installer")

puts notice("Afterward, install ruby : rbenv install `cat ~/.rbenv-version`")

Dir.chdir start_dir
