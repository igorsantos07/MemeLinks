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
  field :name_lower
  slug :name, :history => true
  field :image, :type => Base64File
  field :image_mime
  field :keywords,        :default => []
  field :external_count,  :default => 0
  field :all_views_count, :default => 0
  belongs_to :creator, :class_name => 'Account'
  belongs_to :updater, :class_name => 'Account'

  index :name, :unique => true
  index :slug, :unique => true

  validates_presence_of :name, :creator
  validates_presence_of :image, :image_mime, :if => proc { |obj| obj.new_record? }
  validates_presence_of :updater, :if => proc { |obj| !obj.new_record? }
  validates_uniqueness_of :name, :slug

  def filename
    ext = case self.image_mime
      when 'image/gif'      then '.gif'
      when 'image/jpeg'     then '.jpg'
      when 'image/jpg'      then '.jpg'
      when 'image/png'      then '.png'
      when 'image/svg+xml'  then '.svg'
      when 'image/svg'      then '.svg'
      when 'image/tiff'     then '.tiff'
      else ''
    end

    self.slug + ext
  end

  def name= name=''
    self[:name] = name
    self[:name_lower] = name.downcase
  end

  def keywords_string= keywords
    list = keywords.split ','
    self.keywords = list.collect! {|word| word.strip.downcase }
    self.keywords.uniq!
  end

  def keywords_string
    self.keywords.join ', '
  end

  def self.find_by_filename filename
    slug = filename[0...filename.index('.')||filename.length]
    self.find_by_slug slug
  end
end