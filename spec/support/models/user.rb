class User
  include ::Mongoid::Document
  include ::Protobuf::Mongoid::Model
  include ::Mongoid::Attributes::Dynamic

  attr_accessor :password

  has_many :photos

  accepts_nested_attributes_for :photos

  scope :by_guid, lambda { |*guids| where(:guid => guids) }
  scope :by_email, lambda { |*emails| where(:email => emails) }

  protobuf_fields :except => :photos

  attribute_from_proto :guid, :guid!
  attribute_from_proto :email, lambda { |proto| proto.email! }
  attribute_from_proto :email_domain, lambda { |proto| proto.email.split("@").last }
  attribute_from_proto :nullify, lambda { |proto| proto.nullify! }
  attribute_from_proto :photos, lambda { |proto| proto.photos.map { |photo| Photo.attributes_from_proto(photo) } }
  attribute_from_proto :name, lambda { |proto| proto.name! }
  attribute_from_proto :first_name, :extract_first_name
  attribute_from_proto :last_name, :extract_last_name
  attribute_from_proto :password, lambda { |proto| proto.password! }

  field_from_document :email_domain, lambda { |document| document.email.split("@").last }
  field_from_document :password, :password_transformer

  def self.password_transformer(user)
    # Simple way to test field transformers that call methods
    user.password
  end

  def token
    "key"
  end

  def name
    "#{first_name} #{last_name}"
  end
end
