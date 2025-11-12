# app/controllers/admin/posts_controller.rb
module Admin
  class PostsController < Admin::BaseController
    before_action :set_post, only: [:show, :approve]

    def show
      @store = @post.store
      render 'admin/posts/show'
    end

# 承認時（例）
def approve
  post  = Post.find(params[:id])
  store = Store.find_or_initialize_by(post_id: post.id)

  store.name              = post.name
  store.prefecture        = post.prefecture
  store.address_detail    = post.address_detail
  store.building_name     = post.building_name
  store.store_type        = post.store_type
  store.budget            = post.budget
  store.smoking_allowed   = post.smoking_allowed
  store.description       = post.description
  store.is_owner          = post.is_owner
  store.holidays          = post.holidays
  store.irregular_holiday = post.irregular_holiday
  store.hours_text        = post.hours_text   # ← 必ずこれを追加
  store.status            = "公開"

  store.save!
  redirect_to admin_post_path(post), notice: "承認しました。"
end

      # Post.images → Store.main_image_1..4 に移送（存在する範囲で）
      if @store.respond_to?(:main_image_1)
        @store.main_image_1.detach if @store.main_image_1.attached?
        @store.main_image_2.detach if @store.main_image_2.attached?
        @store.main_image_3.detach if @store.main_image_3.attached?
        @store.main_image_4.detach if @store.main_image_4.attached?

        if @post.respond_to?(:images) && @post.images.present?
          %w[main_image_1 main_image_2 main_image_3 main_image_4].each_with_index do |slot, i|
            blob = @post.images[i]&.blob
            @store.send(slot).attach(blob) if blob
          end
        end
      end

      @store.save!
      @post.update!(status: '公開')

      redirect_to admin_store_path(@store), notice: '店舗申請が承認されました'
    rescue => e
      flash[:alert] = '承認に失敗しました'
      redirect_to admin_post_path(@post)
    end

    private

    def set_post
      @post = ::Post.find(params[:id])
    end
  end
end
