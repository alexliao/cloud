require 'json'

class AppsController < ApplicationController
  include FileHelper
  #before_filter :redirect_anonymous
  before_filter :log_access
  
  #api
  def status
    return unless validate_format
    app = App.find(:first, :conditions => ["package=? and signature=?", params[:package], params[:signature]])
    #app = App.new(:package => params[:package], :signature => params[:signature]) unless app
    if app
#      user = User.ensure(params[:imei], {:lang => params[:lang], :client_version => params[:client_version], :country_code => params[:country]})
      AppLocale.addUnlessNone(params[:lang], params[:country], app, params["name"])
#      Install.add(user, app)
    else
      app = App.new(:package => params[:package], :signature => params[:signature])
    end
#    app = App.create(:package => params[:package], :signature => params[:signature], :name => params[:name]) unless app
#    AppLocale.addUnlessNone(params[:lang], params[:country], app, params[:name])
#    user = User.ensure(params[:imei], {:lang => params[:lang], :client_version => params[:client_version], :country_code => params[:country]})
#    Install.addUnlessNone(user, app)
#    app.id = nil if app.apk.nil?
    api_response app.facade, "app"
  end
   
  def status_list2
    _status_list
    hash = {:user => @user, :apps => @cloud_apps}
    api_response hash.facade
  end
  
  def status_list
    _status_list
    api_response @cloud_apps.facade, "apps"
  end

  def _status_list
    return unless validate_format
#    @user = User.ensure(params[:imei], {:lang => params[:lang], :client_version => params[:client_version], :country_code => params[:country]})
    @user = @current_user
    @cloud_apps = []
    local_apps = JSON.parse(params[:apps])
#    Install.remove_all(@user)
    local_apps.each do |la|
      app = App.find(:first, :conditions => ["package=? and signature=?", la["package"], la["signature"]])
#      app = App.create(:package => la["package"], :signature => la["signature"], :name => la["name"]) unless app
#      AppLocale.addUnlessNone(params[:lang], params[:country], app, la["name"])
#      Install.add(@user, app)
#      app.id = nil if app.apk.nil?
      if app
        AppLocale.addUnlessNone(params[:lang], params[:country], app, la["name"], la["version_code"])
#        Install.add(@user, app)
      else
        app = App.new(:package => la["package"], :signature => la["signature"])
      end
      @cloud_apps << app
    end
  end

  #api
  def upload
    return unless validate_format
    @user = @current_user
    app = _add_app
    if app
#      if params[:imei]
#        @user = User.ensure(params[:imei], {:lang => params[:lang], :client_version => params[:client_version], :country_code => params[:country]})
        AppLocale.remove(params[:lang], params[:country], app)
        AppLocale.addUnlessNone(params[:lang], params[:country], app, params[:name], params[:version_code])
#        Install.add(@user, app)
#      end
      api_response app.facade(), "app"
    else
      api_error api_errors2hash(@user.errors), 400
    end
  end
    
  def show
    @app = App.find(:first, :conditions => ["id=?", params[:id]])
  end  
  
  #api
  def remove
    #user = User.find_by_imei(params[:imei])
#    user = User.ensure(params[:imei], {:lang => params[:lang], :client_version => params[:client_version], :country_code => params[:country]})
    if params[:id]
      app = App.find(params[:id])
    else
      app = App.find_by_package_and_signature(params[:package], params[:signature])
    end
#    Install.remove(user, app)
    render :nothing => true
  end
  
  #api
  def check
    return unless validate_format
    return unless validate_signin

    #recent_update = Upload.find(:first, :joins => "join follows f on f.user_id=#{@current_user.id} and f.following_id=uploads.user_id", :order => "uploads.id desc")
    #recent_update_id = recent_update.id if recent_update
    if params[:since_time]
      new_updates_count = Upload.count(:joins => "join follows f on f.user_id=#{@current_user.id} and f.following_id=uploads.user_id", :conditions => "uploads.created_at >= '#{params[:since_time]}'")
    end
    ret = Hash.new
    ret[:check_time] = Time.now.short_time
    ret[:new_updates_count] = new_updates_count || 0
    api_response ret
  end
#-------------------------------------------------------------------------  
protected

  def _add_app
#    begin
      infos = {:name => params[:name], :package => params[:package], :signature => params[:signature], :version_code => params[:version_code], :version_name => params[:version_name] }
      iu = save_app(params[:icon_file], params[:apk_file], infos)
      return iu
#    rescue Exception => exc
#      @user.errors.add :exception, exc.message
#      return false
#    end
  end

  def save_app(icon, apk, infos)
#    save_name = ((Time.now-Time.gm(2011))*1000).to_i.to_s
#    postfix = get_suffix(upload_field.original_filename)
#    postfix = sub_type(upload_field) if postfix == ''
#    #file_name = sanitize_filename(upload_field.original_filename).split('.')[0]
#    save_name = "#{save_name}.#{postfix}"
#    save_url = "#{url_dir}/#{save_name}"
#    save_path = "public#{save_url}"
##    if upload_field.methods.include?("local_path") and upload_field.local_path
##      #system "chmod", "644", upload_field.local_path
##      FileUtils.copy upload_field.local_path, save_path
##    else
#      File.open(save_path, "wb") { |f| f.write(upload_field.read) }
##    end
    
    #hashId = (infos[:package]+infos[:signature]).hash.to_s
    
    name = genApkName(infos[:package], infos[:signature])
    icon_url, icon_path = save_file(icon, get_picture_dir, name)
    apk_url, apk_path = save_file(apk, get_apk_dir, name)
    infos = infos.update({:icon=>icon_url, :apk => apk_url, :size=>File.size(apk_path)})

    app = App.find(:first, :conditions => ["package=? and signature=?", infos[:package], infos[:signature]])
    if app
      old_apk_path = "public#{app.apk}"
      old_icon_path = "public#{app.icon}"
      FileUtils.rm(old_apk_path, :force => true) if old_apk_path != apk_path
      FileUtils.rm(old_icon_path, :force => true) if old_icon_path != icon_path
      app.update_attributes(infos)
    else
      app = App.create(infos)
    end
    return app
  end
  
  def genApkName(package, signature)
    exist_count = App.count :conditions => ["package = ? and signature <> ?", package, signature]
    if exist_count == 0
      ret = package
    else
      ret = "#{package}.#{exist_count+1}"
    end
    ret
  end
  
  def save_file(upload_field, dir, save_name)
    #save_name = ((Time.now-Time.gm(2011))*1000).to_i.to_s
    postfix = get_suffix(upload_field.original_filename)
    postfix = sub_type(upload_field) if postfix == ''
    #file_name = sanitize_filename(upload_field.original_filename).split('.')[0]
    save_name = "#{save_name}.#{postfix}"
    save_url = "#{dir}/#{save_name}"
    save_path = "public#{save_url}"
#    if upload_field.methods.include?("local_path") and upload_field.local_path
#      #system "chmod", "644", upload_field.local_path
#      FileUtils.copy upload_field.local_path, save_path
#    else
      File.open(save_path, "wb") { |f| f.write(upload_field.read) }
#    end
    return save_url, save_path
  end
end