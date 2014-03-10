require 'net/http'
require 'rexml/document'
class App < ActiveRecord::Base
  include CommonHelper
  include FileHelper
  has_many :locales, :class_name => "AppLocale"
  attr_accessible :package, :signature, :id, :name, :version_code, :version_name, :icon, :apk

  def facade()
    ret = {}
    ret[:id] = self.id
    ret[:name] = self.name
    ret[:package] = self.package
    ret[:signature] = self.signature
    ret[:version_code] = self.version_code
    ret[:version_name] = self.version_name
    ret[:icon] = self.icon
    ret[:apk] = self.apk
    ret[:created_at] = self.created_at
    ret[:updated_at] = self.updated_at
    ret
  end

#  def local_name(code)
#    locale = locales.find(:first, :conditions => ["code = ?", code])
#    ret = locale.name if locale
#    unless ret
#      a = code.split("_")
#      locale = locales.find(:first, :conditions => ["code = ?", a[0]])
#      ret = locale.name if locale
#    end
#    ret || self.name
#  end

  def local_name(languages)
    ret = nil
    lrs = languages.split(",")
    lrs.each do |lr|
      code = lr.split(";")[0]
      locale = locales.find(:first, :conditions => ["code = ?", code])
      ret = locale.name if locale
      break if ret
    end
    ret || self.name
  end

end
