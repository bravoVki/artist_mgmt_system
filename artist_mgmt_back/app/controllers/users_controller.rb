class UsersController < ApplicationController
  skip_before_action :authorize_request, only: [:register]

  # before doing actions inside [], first runs outside bala on for inside bala 
  before_action :set_user, only: %i[ show update destroy ]
  before_action :check_owner,only: %i[ destroy]

  # GET /users
  def index
    @users = User.page(params[:page]).per(5)
    render json: {
      statu:"success",
      message:"Loaded all users",
      data:@users,
      meta:pagination_meta(@users)
    }
  end

  # GET /users/1
  def show
    render json:@users
  end

  # POST /users/register
  def register
    @user = User.new(user_params)

    if @user.save
      # render json: @user, status: :created, location: @user
      render json: {
        status:"Success",
        message:"User registered",
        # data: user_serializer(@user)
        }
    else
      # render json: @user.errors, status: :unprocessable_entity
      render json: {
        status:"unprocessable_entity", 
        message:@user.errors,
        # data:user_serializer(@json)
      }
    end
  end



  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: {status:"success", data:user_serializer(@user)}
    else
      render json: {status: :unprocessable_entity, error:@user.errors,}
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :phone, :dob, :gender, :address,)
  end
  def pagination_meta(object)
    {
      total_pages: object.total_pages,
      current_page: object.current_page,
      next_page: object.next_page,
      prev_page: object.prev_page,
      total_count: object.total_count
    }
  end
# ################################################################# response ma chahiney jati values halne yaha, also do it for all others
  def user_serializer(user)
    return {
      f_name: user.first_name,
      Email: user.email,
      l_name: user.last_name,
      Phone: user.phone,
      Dob: user.dob,
      Gender: user.gender,
      Address: user.address

    }
  end

  # checks current user and user on which action is being carried out, means current user can update or delete only itself, ali change gareko, if current user xa vane aafulai dlt garna na milne
 def check_owner
  head :forbidden unless @user.id != current_user.id
  
 end
end
