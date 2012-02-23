class Meme
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  field :slug, :type => String
  field :name, :type => String
  field :image, :type => String, :default => nil

  index :slug, :unique => true
  index :name, :unique => true

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
