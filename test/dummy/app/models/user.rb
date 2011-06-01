# encoding: UTF-8

class User < ActiveRecord::Base
  
  #extend RussianAttributes
  #include Roles::Generic
  #include Roles::ActiveRecord
  
  #strategy :many_roles 
  #valid_roles_are :user, :student, :curator, :instructor, :admin

  #add_role_group :administration => [:admin, :curator]
  #add_role_group :bloggers => [:admin]
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  #devise :database_authenticatable, :authentication_keys => [:login]
  #devise :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable

  #has_attached_file :avatar, :default_url => "/icons_avatars/:style/no_avatar.svg"
  #, :styles => { :medium => "300x300>", :thumb => "100x100>"}
  # Setup accessible (or protected) attributes for your model
  #attr_accessor :login
  #attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :login, :avatar, :name, :surname, :middlename, :about_me, :mobile_number, :passport, :real_address, :city, :role_input, :role
  #acts_as_reader

  # Associations
  
  has_one :questionnaire_status
  has_one :questionnaire, :through => :questionnaire_status
  has_one :contract
  has_one :workbook
  has_many :payments, :order => :created_at
  
  has_many :formulars, :foreign_key => "user_id"
  has_many :instructors, :through => :formulars, :class_name => "User"

  has_many :students_formulars, :class_name => "Formular", :foreign_key => "instructor_id"
  has_many :students, :through => :students_formulars, :source => :user
  accepts_nested_attributes_for :formulars, :allow_destroy => true,
    :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
 
  has_many :courses, :through => :formulars

  has_many :associated_course_instructors, :foreign_key => "instructor_id"
  has_many :associated_courses_assigned, :through => :associated_course_instructors, :source => :associated_course

  has_many :course_instructors, :foreign_key => "instructor_id"
  has_many :courses_assigned, :through => :course_instructors, :source => :course

  has_many :news, :foreign_key => 'author_id'

  has_many :game_statistics, :class_name => "GameStatistics"
  has_many :games, :through => :game_statistics
  
  # Scopes
  scope :last_registered, :conditions => ["created_at >= ?", 5.days.ago] #order('id DESC')
  scope :masquerade_for, lambda{|user| where("\"id\" != :user_id", {:user_id => user.id}).select("id, username")}
  scope :for_index, select('id, surname, name, username, middlename, email')
  #scope :recent_logins, order('last_sign_in_at').where("\"sign_in_count\" > 0") #.where("")
  
  # Validations
  #validates_presence_of :username, :message => "не заполнено!"
  #validates_presence_of :name, :message => "не заполнено!"
  #validates_presence_of :middlename, :message => "не заполнено!"
  #validates_presence_of :surname, :message => "не заполнено!"
   
  # Callbacks
  before_create do
    #self.role = :user if roles.empty?
  end

  after_create do
    #Activity.process_activity!(:user_registered, {:user => self}, [id], self.class.curators_ids) if role==:user
  end
 
  # Russian maps
  HUMAN_ROLES = [ [ "Пользователь", :user], [ "Инструктор", :instructor], [ "Куратор", :curator], [ "Администратор", :admin], [ "Студент", :student] ]

  # Class methods
  class << self

    def role_human_name(role_in_symbol)
      HUMAN_ROLES.each{|role| return role[0] if role[1] == role_in_symbol }
    end
    
    def curators_ids
      Role.find_by_name("curator").user_ids
    end
   
    def instructors_ids
      Role.find_by_name("instructor").user_ids
    end
 
    def all_without_admins
      all = []
      valid_roles.without(:admin).each do |rolle|
        all << Role.find_by_name(rolle).users
      end
      all
    end
  
    def curators
      Role.find_by_name("curator").users 
    end
 
    def instructors
      Role.find_by_name("instructor").users
    end
    
  end

  # Instance methods
  def role
    return roles_list[0] #role_input #unless self.is?(:user) 
  end
 
  def role_input
    roles_list[0].to_s  
  end

  def role_input=(role_string)
    if role_string == 'student' && self.roles_list.include?(:user)
      promote_to_student!
    else
      self.role = role_string.to_sym
    end
  end
 
  def promote_to_student!
    self.role = :student
    save!
    Activity.process_activity!(:user_gets_student_status, {:user => self}, [id], self.class.curators_ids)
  end

  def role_as_class
    return "user-#{self.roles_list[0].to_s}"
  end
  
  def has_courses?
    formulars.exists? 
  end
 
  def has_paid_for_course?(course)
    Payment.where(:user_id => id).where(:context => :course.to_yaml).each do |payment|
      if payment.payment_for[:course_id] == course.id.to_s
        return true 
      end
    end
    false
  end
  
  def is_on_course?(course)
    return true if formular_for(course)
    return false
  end

  def formular_for(course)
    formulars.each do |formular|
      return formular if formular.course == course
    end
    return nil
  end

  # ! не обновляем количество посещений для маскарадного пользователя
  def update_tracked_fields!(request)  
    if request.session[:masquerade] == true
      return
    end
    Activity.process_activity!(:admin_user_sign_in, {:user => self}, [id], [])
    super(request)
  end

  # Заглушка для masquerade::select
  def to_masquerade
  end

  def instructors_from_all_courses
    @all_instructors = []
    formulars.each do |f|
      @all_instructors = @all_instructors + ([f.instructor] + f.instructors_from_associated_courses)
    end
    @all_instructors.compact
  end

  protected

  def self.find_for_database_authentication(conditions)
    login = conditions.delete(:login)
    where(conditions).where(["username = :value OR email = :value", {:value => login}]).first
  end
  def self.send_reset_password_instructions(attributes={})
    recoverable = find_recoverable_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    recoverable.send_reset_password_instructions if recoverable.persisted?
    recoverable
  end 
  
  def self.find_recoverable_or_initialize_with_errors(required_attributes, attributes, error=:invalid)
    case_insensitive_keys.each { |k| attributes[k].try(:downcase!) }
    attributes = attributes.slice(*required_attributes)
    attributes.delete_if { |key, value| value.blank? }
  
    if attributes.size == required_attributes.size
      if attributes.has_key?(:login)
        login = attributes.delete(:login)
        record = find_record(login)
      else  
        record = where(attributes).first
      end  
    end  
  
    unless record
      record = new
    
      required_attributes.each do |key|
        value = attributes[key]
        record.send("#{key}=", value)
        record.errors.add(key, value.present? ? error : :blank)
      end  
    end  
    record
  end
  
  def self.find_record(login)
    where(attributes).where(["username = :value OR email = :value", { :value => login }]).first
  end
end
