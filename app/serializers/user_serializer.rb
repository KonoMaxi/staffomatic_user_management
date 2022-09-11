class UserSerializer
  include JSONAPI::Serializer
  attributes :email, :archived
end
