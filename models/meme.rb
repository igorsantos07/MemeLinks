class Meme
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  include Mongoid::Slug

  field :name
  belongs_to :creator, :class_name => 'Account'
  belongs_to :updater, :class_name => 'Account'
  slug :name, :history => true

  index :name, :unique => true
  index :slug, :unique => true

  validates_presence_of :name, :creator
  validates_presence_of :updater, :if => proc { |obj| !obj.new_record? }
  validates_uniqueness_of :name, :slug
end