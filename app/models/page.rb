class Page < ActiveRecord::Base
  before_validation :generate_slug
  validates :slug, :uniqueness => true

  attr_accessible :body, :slug, :title, :visibility

  def generate_slug
    if self.slug.blank?
      self.slug = self.title.downcase.gsub(/ /, "-").gsub(/[\'\"\?\&]/, "")
    end
  end

  def to_param
    self.slug
  end

end
