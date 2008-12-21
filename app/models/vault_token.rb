class VaultToken
  include DataMapper::Resource
  
  property :id,     Serial
  property :token,  String, :nullable => false

  belongs_to :user
end
