class ContactsController < ApplicationController
  before_action :set_contact, only: %i[ show edit update destroy ]

  include SetTenant #set ActsAsTenant.current_tenant
  include RequireTenant #no current_tenant = no access to entire controller
  include SetCurrentMember #for role-based authorization

  before_action :require_admin_or_editor, only: [:edit, :update, :destroy]
  def require_admin_or_editor
    if @current_member.admin? || @current_member.editor?
      # success
    else
      redirect_to contacts_path, alert: "You are not authorized"
    end
  end
  
  def index
    @contacts = Contact.all
  end

  def show
  end

  def new
    @contact = Contact.new
  end

  def edit
  end

  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: "Contact was successfully created." }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: "Contact was successfully updated." }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: "Contact was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_contact
      @contact = Contact.find(params[:id])
    end

    def contact_params
      params.require(:contact).permit(:first_name, :last_name, :phone_number, :email)
    end
end
