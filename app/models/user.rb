# require 'gettext/rails'
require 'json'
class User < ActiveRecord::Base
  include CommonHelper
  has_and_belongs_to_many :followings, :class_name => "User", :foreign_key => "user_id", :association_foreign_key => "following_id", :join_table => "follows"
  has_and_belongs_to_many :followers, :class_name => "User", :foreign_key => "following_id", :association_foreign_key => "user_id", :join_table => "follows"
  has_many :installs

  def facade()
    ret = {}
    ret[:id] = self.id
    ret[:name] = self.name
    ret[:imei] = self.name
    ret[:created_at] = self.created_at
    ret[:updated_at] = self.updated_at
    ret
  end

  # read and refresh cached count
  def followings_count(refresh = false)
    ret = refresh ? nil : read_attribute("followings_count")
    unless ret
      ret = self.followings(:refresh).count
      self.update_attribute(:followings_count, ret)
    end
    ret
  end
  def followers_count(refresh = false)
    ret = refresh ? nil : read_attribute("followers_count")
    unless ret
      ret = self.followers(:refresh).count
      self.update_attribute(:followers_count, ret)
    end
    ret
  end
  def installs_count(refresh = false)
    ret = refresh ? nil : read_attribute("apps_count")
    unless ret
      ret = self.installs(:refresh).count
      self.update_attribute(:apps_count, ret)
    end
    ret
  end
  
  def self.ensure(imei, params)
    user = User.find(:first, :conditions => ["imei = ?", imei])
    params[:imei] = imei
    user = User.create(params) unless user
    user
  end

end
