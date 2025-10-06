# config/puma.rb

max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# 開発用の timeout 設定
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

port ENV.fetch("PORT") { 3000 }

# 本番環境で起動させたいのでデフォルトを production に
environment ENV.fetch("RAILS_ENV") { "production" }

pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# マルチプロセス対応
workers ENV.fetch("WEB_CONCURRENCY") { 2 }
preload_app!

plugin :tmp_restart

# アプリケーションルートを取得
app_root = File.expand_path("../..", __FILE__)

# ソケット経由でNginxと連携
bind "unix://#{app_root}/tmp/sockets/puma.sock"

# systemd が管理するので daemonize は不要
