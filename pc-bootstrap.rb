#!/usr/bin/env ruby
load 'common.rb'

# Assumes the following programs have been installed and configured: homebrew & git
# Also assumes you've checked out the dotfiles repository :)
#TODO: Override symlinks
#TODO: Check for existing configurations
#TODO: Ask if user wants to autoload

start_dir = Dir.pwd
home = File.expand_path "~"
dot_folder = home + "/.dotfiles"

# symlink all dotfiles in folder
puts info("Symlinking dotfiles")
Dir.chdir "#{dot_folder}/dotfiles"
files = Dir.entries(Dir.pwd)
files.delete_if {|file_name| file_name.match(/\.{1,2}$/) }
files.each { |file| system "ln -s -Ff #{dot_folder}/dotfiles/#{file} #{home}/#{file}" }

# Install default ruby
ruby_version = File.read("#{dot_folder}/dotfiles/.ruby-version").strip

puts "Installing homebrew packages"
system "brew bundle" 

# Emacs special sauce
# system "brew install emacs --cocoa"

puts info("Installing Ruby #{ruby_version}")
system "rbenv install #{ruby_version}"

# Use ZSH as primary shell
zsh    = "/usr/local/bin/zsh"
shells = "/etc/shells"
if open(shells).grep(Regexp.new(zsh)).empty?
  puts info("Adding '#{zsh}' to '#{shells}' file")
  system "echo '#{zsh}' | sudo tee -a #{shells}"
end

puts info("Setting ZSH as primary shell")
system "chsh -s #{zsh} jburris"

Dir.chdir start_dir

puts info("Please type `exec /usr/local/bin/zsh -l` and then run pc-setup.rb")

exit
