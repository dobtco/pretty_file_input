class UsersController < ActionController::Base
  layout 'application'

  before_action :error_hack, only: [:update]
  before_action :loading_hack, only: [:update]

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
    @user = User.find(params[:id])
    @user.update(user_params)

    if params[:pretty_file_input]
      request.format = :json
    end

    respond_to do |format|
      format.json { render json: { ok: true } }
      format.html { redirect_to edit_user_path }
    end
  end

  private

  def user_params
    params.require(:user).permit!
  end

  def error_hack
    if user_params[:avatar]
      if user_params[:avatar].original_filename.match('unknownerror')
        head :bad_request
      elsif user_params[:avatar].original_filename.match('error')
        render(
          json: { error: 'This is a server-generated error message.' },
          status: :bad_request
        )
      end
    end
  end

  def loading_hack
    if user_params[:avatar]
      if user_params[:avatar].original_filename.match('loading')
        sleep 3
      end
    end
  end
end
