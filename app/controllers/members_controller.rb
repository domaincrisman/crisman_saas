class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  before_action :require_tenant
  #if no tenant is set results are unscoped (acts_as_tenant)
  #this is required for all models that will be using acts_as_tenant(:tenant)
  #info: https://github.com/ErwinM/acts_as_tenant#scoping-your-models
  def require_tenant
    if current_tenant.nil?
      redirect_to root_path, alert: "No tenant set!"
    end
  end

  def index
    @members = Member.all
  end

  def invite
    email = params[:email]
    user_from_email = User.where(email: email).first
    if user_from_email.present? #user exists in the database
      if Member.where(user: user_from_email).any? #user is a member in current_tenant
        redirect_to members_path, alert: "The organization #{current_tenant.name} already has a user with the email #{email}"
      else #user is not a member of current_tenant
        Member.create!(user: user_from_email) #create member for existing user
        redirect_to members_path, notice: "#{email} was invited to join the organization #{current_tenant.name}"
        #send email that user was invited to this tenant
      end
    elsif user_from_email.nil? #invite new user to a tenant
      new_user = User.invite!({email: email}, current_user) #devise invitable create user and send email. invited_by current_user
      Member.create!(user: new_user) #make new user part of this tenant
      redirect_to members_path, notice: "#{email} was invited to join the tenant #{current_tenant.name}"
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to @member, notice: "Member was successfully updated." }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to members_url, notice: "Member was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_member
      @member = Member.find(params[:id])
    end

    def member_params
      params.require(:member).permit(:user_id)
    end
end
