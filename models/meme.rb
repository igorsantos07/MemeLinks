class Base64File
  include Mongoid::Fields::Serializable
  require 'base64'

  def serialize data
    Base64.encode64 data
  end

  def deserialize data
    Base64.decode64 data
  end
end

class Meme
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  include Mongoid::Slug
  require 'base64'

  field :name
  field :image, :type => Base64File
  field :image_mime
  belongs_to :creator, :class_name => 'Account'
  belongs_to :updater, :class_name => 'Account'
  slug :name, :history => true

  index :name, :unique => true
  index :slug, :unique => true

  validates_presence_of :name, :creator
  validates_presence_of :image, :image_mime, :if => proc { |obj| obj.new_record? }
  validates_presence_of :updater, :if => proc { |obj| !obj.new_record? }
  validates_uniqueness_of :name, :slug
end