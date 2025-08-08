class GrumblesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!, except: [:index]

  def new
    @grumble = Grumble.new
  end

  def create
    @grumble = current_user.grumbles.build(grumble_params)
    if @grumble.save
      redirect_to grumbles_path, notice: "投稿しました"
    else
      render :new, alert: "投稿に失敗しました"
    end
  end

  def index
    @grumbles = Grumble.order(created_at: :desc).page(params[:page]).per(18)
  end

  def like
    @grumble = Grumble.find(params[:id])
    current_user.likes.find_or_create_by!(grumble: @grumble)

    # Turbo Frame が待っているので、同じフレームを含むHTMLを返す
    render partial: "grumbles/like_button", locals: { grumble: @grumble }
  end

  def unlike
    @grumble = Grumble.find(params[:id])
    current_user.likes.find_by(grumble: @grumble)&.destroy

    render partial: "grumbles/like_button", locals: { grumble: @grumble }
  end

  def destroy
    @grumble = Grumble.find(params[:id])
    if @grumble.user == current_user
      @grumble.destroy
      redirect_to grumbles_path, notice: "投稿を削除しました"
    else
      redirect_to grumbles_path, alert: "自分の投稿しか削除できません"
    end
  end

  private

  def grumble_params
    params.require(:grumble).permit(:content)
  end
end
