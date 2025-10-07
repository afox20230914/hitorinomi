# ============================================
# Puma 設定ファイル（軽量版 / Cloud9・開発向け）
# ============================================

# スレッド数（最小・最大）
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# タイムアウト（開発時のみ長めに）
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# ポート
port ENV.fetch("PORT") { 3000 }

# 環境設定（開発時は development）
environment ENV.fetch("RAILS_ENV") { "development" }

# PID ファイル
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# ------------------------------------------------
# 💡 ワーカーは1でOK（Cloud9 / EC2 はメモリ少ない）
# ------------------------------------------------
workers ENV.fetch("WEB_CONCURRENCY") { 1 }

# 開発中は preload_app! 不要（メモリ節約のためコメントアウト）
# preload_app!

# tmp_restart プラグイン（`rails restart` で再起動できる）
plugin :tmp_restart

# ------------------------------------------------
# 💡 開発中はソケット不要（Nginx連携しない）
# ------------------------------------------------
# 本番運用時に Nginx 連携が必要なら、以下を有効化：
# app_root = File.expand_path("../..", __FILE__)
# bind "unix://#{app_root}/tmp/sockets/puma.sock"
