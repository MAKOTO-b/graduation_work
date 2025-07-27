class GrumblesController < ApplicationController
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
    @grumble.likes.find_or_create_by(user: current_user)
      respond_to do |format|
      format.js
    end
  end

  def unlike
    @grumble = Grumble.find(params[:id])
    @grumble.likes.find_by(user: current_user)&.destroy
    respond_to do |format|
      format.js
    end
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
