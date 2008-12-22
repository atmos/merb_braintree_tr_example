class VaultToken
  include DataMapper::Resource
  
  property :id,     Serial
  property :token,  String, :nullable => false

  belongs_to :user
#  validates_is_unique :token, :scope => [:user_id]
end
