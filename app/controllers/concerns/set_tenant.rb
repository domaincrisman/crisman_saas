module SetTenant
  extend ActiveSupport::Concern
  
  included do
    set_current_tenant_through_filter #acts_as_tenant
    before_action :set_tenant

    def set_tenant
      if current_user
        if current_user.tenant_id.present?
          if current_user.tenants.include?(current_user.tenant)
            #current_account = Tenant.find_by(id: current_user.tenant_id) #does not require belongs_to relationship
            current_account = current_user.tenant #requires belongs_to relationship
            #User.find_by(email: "wawa@w.com").update_attributes!(tenant_id: 2)
            set_current_tenant(current_account)
          else
            set_current_tenant(nil)
          end
        else
          set_current_tenant(nil)
        end
      else
        set_current_tenant(nil)
      end
    end
  end
end