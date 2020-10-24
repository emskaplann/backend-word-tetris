class TextDataFile < ApplicationRecord
    include ActiveModel::Serialization
    attr_accessor :id, :name, :timestamp, :link
    def attributes
        {'id' => nil, 'name' => nil, 'timestamp' => nil, 'link' => nil}
    end
end
