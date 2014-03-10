class Install < ActiveRecord::Base
  set_primary_key  "install_id"
  belongs_to :user
  belongs_to :app

  def self.add(user, app)
    record = Install.new(:user_id => user.id, :app_id => app.id)
    record.save
    user.installs_count(true)
    record
  end

  def self.addUnlessNone(user, app)
    record = Install.find(:first, :conditions => ["user_id = ? and app_id = ?", user.id, app.id])
    record = add(user, app) unless record
    record
  end

  def self.remove(user, app)
    Install.delete_all("user_id = #{user.id} and app_id = #{app.id}")
    user.installs_count(true)
  end
  
  def self.remove_all(user)
    Install.delete_all("user_id = #{user.id}")
    user.installs_count(true)
  end

  def self.refresh(user, app)
    connection.execute("update installs set updated_at = now() where user_id = #{user.id} and app_id = #{app.id}")
  end

end
