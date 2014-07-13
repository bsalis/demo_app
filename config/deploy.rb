# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'demo_app'
set :scm, :git
#set :repo_url, 'git@github.com:bsalis/demo_app.git'   TODO this needs ssh key forwarding setup
set :repo_url, 'https://github.com/bsalis/demo_app.git'
set :branch, 'master'
set :user, 'ec2-user'
set :tmp_dir, '/tmp'
set :deploy_to, '/home/ec2-user/demo_app'
set :format, :pretty
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
#set :default_env, { path: '/opt/ruby/bin:$PATH' }
set :default_env, { path: '/home/ec2-user/.rvm/gems/ruby-2.1.2/bin:/home/ec2-user/.rvm/gems/ruby-2.1.2@global/bin:/home/ec2-user/.rvm/rubies/ruby-2.1.2/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/aws/bin:/home/ec2-user/.rvm/bin:/home/ec2-user/bin' }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :unicorn_config, "#{current_path}/config/unicorn.rb"
#set :unicorn_binary, "PATH=#{fetch(:default_env)[:path]} unicorn_rails -c #{fetch(:unicorn_config)} -E #{fetch(:rails_env)} -D"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

namespace :deploy do

#  desc 'Start Unicorn'
#  task :start do
#    on roles(:app) do
#      execute "cd #{current_path} && #{fetch(:unicorn_binary)}"
#    end
#  end
#  
#  desc 'Stop Unicorn'
#  task :stop do
#    on roles(:app) do
#      execute "if [ -f #{fetch(:unicorn_pid)} ]; then kill `cat #{fetch(:unicorn_pid)}`; fi"
#    end
#  end

  desc 'Restart application'
  task :restart do
    on roles(:app), 'in'.to_sym => :sequence, wait: 5 do
      execute "if [ -f #{fetch(:unicorn_pid)} ]; then kill -QUIT `cat #{fetch(:unicorn_pid)}`; fi"
      sleep 5
      unicorn_binary = "PATH=#{fetch(:default_env)[:path]} unicorn_rails -c #{fetch(:unicorn_config)} -E #{fetch(:rails_env)} -D"
      execute "cd #{current_path} && #{unicorn_binary}"
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), 'in'.to_sym => :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

desc "Check that we can access everything"
task :check_write_permissions do
  on roles(:all) do |host|
    if test("[ -w #{fetch(:deploy_to)} ]")
      info "#{fetch(:deploy_to)} is writable on #{host}"
    else
      error "#{fetch(:deploy_to)} is not writable on #{host}"
    end
  end
end

desc "Check that we can access everything"
task :foo do
  on roles(:all) do |host|
    puts 'fooo'
    sleep 5
    puts 'bar'
  end
end

