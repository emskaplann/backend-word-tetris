class TextDataFileSerializer < ActiveModel::Serializer
    attributes :id, :id_column, :name_column, :timestamp_column, :link
end
  