class UsersController < ActionController::Base
  layout 'application'

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    redirect_to edit_user_path(@user)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    # Hack for testing errors
    if user_params[:avatar]
      if user_params[:avatar].original_filename.match('unknownerror')
        return head :bad_request
      elsif user_params[:avatar].original_filename.match('error')
        return render(
          json: { error: 'This is a server-generated error message.' },
          status: :bad_request
        )
      end
    end

    @user = User.find(params[:id])
    @user.update(user_params)

    respond_to do |format|
      format.json { render json: { ok: true } }
      format.html { redirect_to edit_user_path }
    end
  end

  private

  def user_params
    params.require(:user).permit!
  end
end
