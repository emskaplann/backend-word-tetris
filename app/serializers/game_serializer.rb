class GameSerializer < ActiveModel::Serializer
  attributes :id, :time, :score, :user
end
