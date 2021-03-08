class Member < ApplicationRecord
  belongs_to :user, counter_cache: true
  #User.find_each { |user| User.reset_counters(user.id, :members) }  
  #belongs_to :tenant #acts_as_tenant includes this

  acts_as_tenant(:tenant) #counter_cache is currently not supported for acts_as_tenant. Pull request https://github.com/ErwinM/acts_as_tenant/pull/225
  #validates_uniqueness_to_tenant :user_id 

  validates :tenant_id, presence: :true
  validates_uniqueness_of :user_id, scope: :tenant_id

  # List user roles
  ROLES = [:admin, :editor, :viewer]

  # json column to store roles
  store_accessor :roles, *ROLES

  # Cast roles to/from booleans
  ROLES.each do |role|
    scope role, -> { where("roles @> ?", {role => true}.to_json) }
    define_method(:"#{role}=") { |value| super ActiveRecord::Type::Boolean.new.cast(value) }
    define_method(:"#{role}?") { send(role) }
  end

  def active_roles # Where value true
    ROLES.select { |role| send(:"#{role}?") }.compact
  end

  #role validation
  validate :must_have_a_role, on: :update
  validate :must_have_an_admin
  
  private

  def must_have_an_admin
    if persisted? &&
      (self.tenant.members.pluck(:roles).count { |h| h["admin"] == true} == 1) && #see to it that
      (roles_changed? && admin == false)
      errors.add(:base, 'The tenant must have at least one admin') 
    end
  end
  def must_have_a_role
    if self.roles.values.none?
      errors.add(:base, "A member must have at least one role")
    end
  end

end
