# config valid only for current version of Capistrano
lock '3.17.0'

set :application, 'yojee-forum'
set :repo_url, 'git@github.com:conficker1805/yojee-forum.git'

# Restart Passenger with restart.txt
set :passenger_in_gemfile, true
set :passenger_restart_with_touch, true

set :rvm_ruby_string, :local              # use the same ruby as used locally for deployment
set :rvm_autolibs_flag, "read-only"
set :bundle_dir, ''
set :bundle_path, nil
set :bundle_flags, '--system --quiet'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/yojee-forum'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Set Rails env to production
set :rails_env, 'production'

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  task :config_bundler do
    on roles(/.*/) do
      # execute :bundle, 'config', '--local deployment', true
      # execute :bundle, 'config', '--local', 'without', "development:test"
      # execute :bundle, 'config', '--local', 'path', shared_path.join('bundle')
      # execute :bundle, 'lock', '--add-platform x86_64-linux'
      execute :bundle, 'config', 'set', '--local', 'path', '/var/www/yojee-forum/shared/bundle'
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end

before 'bundler:install', 'deploy:config_bundler'
