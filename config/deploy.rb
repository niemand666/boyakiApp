# config valid only for current version of Capistrano
# capistranoのバージョンを記載。固定のバージョンを利用し続け、バージョン変更によるトラブルを防止する
lock '3.11.2'

# Capistranoのログの表示に利用する
set :application, 'boyakiApp'

# どのリポジトリからアプリをpullするかを指定する
set :repo_url,  'git@github.com:niemand666/boyakiApp.git'

# バージョンが変わっても共通で参照するディレクトリを指定
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

set :rbenv_type, :user
set :rbenv_ruby, '2.5.1' #カリキュラム通りに進めた場合、2.5.1か2.3.1です

# どの公開鍵を利用してデプロイするか
set :ssh_options, auth_methods: ['publickey'],
                  keys: ['~/.ssh/boyakiapp.pem'] 

# プロセス番号を記載したファイルの場所
set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }

# Unicornの設定ファイルの場所
set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }
set :keep_releases, 5

#secrets.ymlではリリースバージョン間でシンボリックリンクにして共有
#credentials.yml.encではmasterkeyにする（今回）
set :linked_files, %w{config/master.key}

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do

 task :restart do
   invoke 'unicorn:restart'
 end

set :unicorn_pid, "/var/tmp/unicorn.pid"
set :unicorn_config_path, "/var/www/boyakiApp/current/config/unicorn/production/unicorn.rb"
set :unicorn_rack_env, "production"
# restartだとキャッシュが残るので下記の書き方でも良い
# task :restart do
#   invoke 'unicorn:stop'
#   invoke 'unicorn:start'
# end

  desc 'upload master.key'
  task :upload do
    on roles(:app) do |host|
      if test "[ ! -d #{shared_path}/config ]"
        execute "mkdir -p #{shared_path}/config"
      end
      upload!('config/master.key', "#{shared_path}/config/master.key")
    end
  end
  before :starting, 'deploy:upload'
  after :finishing, 'deploy:cleanup'

end


# master.key用のシンボリックリンクを追加
# set :linked_files, %w[config/master.key]
# set :linked_files, fetch(:linked_files, []).push("config/master.key")

# デプロイ処理が終わった後、Unicornを再起動するための記述
# after 'deploy:publishing', 'deploy:restart'
# namespace :deploy do
#   task :restart do
#     invoke 'unicorn:restart'
#   end

#   desc 'upload master.key'
#   task :upload do
#     on roles(:app) do |_host|
#       execute "mkdir -p #{shared_path}/config" if test "[ ! -d #{shared_path}/config ]"
      # upload!('config/master.key', "#{shared_path}/config/master.key")
#     end
#   end
#   before :starting, 'deploy:upload'
#   after :finishing, 'deploy:cleanup'
# end

# set :default_env, {
#  rbenv_root: "/usr/local/rbenv",
#  path: "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH",
#  AWS_ACCESS_KEY_ID: ENV["AWS_ACCESS_KEY_ID"],
#  AWS_SECRET_ACCESS_KEY: ENV["AWS_SECRET_ACCESS_KEY"]
# }
