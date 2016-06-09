class Api::V1::UserSerializer < Api::V1::BaseSerializer
  attributes :id, :email, :first_name, :last_name, :created_at, :updated_at, :city, :age, :avatar

end