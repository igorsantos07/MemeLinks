# -*- encoding : utf-8 -*-
class Base64File
  include Mongoid::Fields::Serializable
  require 'base64'

  def serialize data
    Base64.encode64 data
  end

  def deserialize data
    Base64.decode64 data unless data.nil?
  end
end

class Meme
  # +:inactive+, +:pending+ or +:active+
  Status = {:inactive => -1, :pending => 0, :active => 1}

  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  include Mongoid::Slug
  require 'base64'

  field :name
  field :name_lower
  slug :name, :history => true
  field :image, :type => Base64File
  field :image_mime
  field :status
  field :ip_user_creator
  field :keywords,        :default => []
  field :external_count,  :default => 0
  field :all_views_count, :default => 0
  belongs_to :creator, :class_name => 'Account'
  belongs_to :updater, :class_name => 'Account'

  index :name, :unique => true
  index :slug, :unique => true

  validates_presence_of :name, :message => 'Faltou o nome!'
  validates_presence_of :creator, :if => proc { |obj| obj.ip_user_creator.nil? }, :message => 'Criador inválido'
  validates_presence_of :status
  validates_presence_of :image, :image_mime, :if => proc { |obj| obj.new_record? }, :message => 'Faltou a imagem!'
  validates_presence_of :updater, :if => proc { |obj| !obj.new_record? }
  validates_uniqueness_of :name, :slug

  scope :tops, desc(:all_views_count).asc(:name_lower)
  scope :active, where(:status => Meme::Status[:active])

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

  def status= status
    if status.class == Symbol
      self[:status] = Meme::Status[status] if Meme::Status.include? status
    else
      status = status.to_i
      self[:status] = status if Meme::Status.has_value? status
    end
  end

  def status_str
    Meme::Status.invert[self[:status]]
  end

  def image_file= file
    return if file.nil? or file.empty?

    self[:image_mime]  = file[:head].match(/Content-Type: ([\w\/-_]*)/i)[1]
    self[:image]       = file[:tempfile].read
  end

  def image_url= url
    return if url.nil? or url.empty?

    require 'net/http'
    image = Net::HTTP.get_response URI(url)
    if image.is_a? Net::HTTPSuccess
      self[:image_mime] = image.get_fields('content-type')[0]
      self[:image]      = image.body
    else
      puts "[ERROR]       Couldn't get image. Return: #{image.class}. URL: #{url}"
    end
  end

  def self.find_by_filename filename
    slug = filename[0...filename.index('.')||filename.length]
    self.find_by_slug slug
  end
end
