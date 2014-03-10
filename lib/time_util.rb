require 'duration'

class Time

  SECOND = 1
  SECONDS = SECOND
  MINUTE = 60
  MINUTES = MINUTE
  HOUR = 3600
  HOURS = HOUR
  DAY = 24 * 3600
  DAYS = DAY
  MONTH = 24 * 3600 * 30.5
  MONTHS = MONTH
  YEAR = 24 * 3600 * 365
  YEARS = YEAR
  
  def prompt(lang, relative = true, short = true)
    if Time.now-self < DAY and relative
      ret = "#{Time.now.distance_to(self, lang)}"
    else
      if lang == 'zh'
        format = short ? self.date_name(lang) : "#{self.date_name(lang)} %H:%M"
      else
        format = short ? self.date_name(lang) : "%I:%M #{self.date_name(lang)}"
      end
      ret = strftime(format)
    end
  end
  
  def local_format(time_zone, lang)
    tz = "%+03d00"%time_zone
    if lang == 'zh'
      self.strftime("%Y年%m月%d日 %H:%M:%S GMT ")+tz
    else
      self.strftime("%a %b %d %H:%M:%S ")+tz+" %d"%self.year
    end
  end
  
  def date_prompt(time_zone_offset)
    now = Time.now + time_zone_offset
    nowdate = Time.mktime(now.year, now.month, now.day)
    date = Time.mktime(self.year, self.month, self.day) 
    if nowdate == date
      ret = ""
    elsif (nowdate - date).to_i == 24*3600
      ret = "Yesterday"
    else
      ret = self.date_name
    end
    ret
  end
  
  def short_time
    strftime('%Y-%m-%d %H:%M:%S')
  end
  
  def short_date
    strftime('%Y-%m-%d')
  end

  def date_name(lang)
    now = Time.now
    nowdate = Time.mktime(now.year, now.month, now.day)
    if lang == 'zh'
      if nowdate.year == self.year
        ret = self.strftime("%m月%d日")
      else
        ret = self.strftime("%Y年%m月%d日")
      end
    else
      if nowdate.year == self.year
        ret = self.strftime("%d %b")
      else
        ret = self.strftime("%d %b, %Y")
      end
    end
    ret
  end
#  def to_date
#    Time.mktime(self.year, self.month, self.day)
#  end
  
#  def year_month_day_hour_minute_second
#    year_month_day + " " + hour_minute_second
#  end

#  def year_month_day_hour_minute
#    year_month_day + " " + hour_minute
#  end

  
#  def month_day_hour_minute(lang='zh')
#    month_day(lang) + " " + hour_minute(lang)
#  end
  
#  def year_month_day(lang='zh')
#    strftime('%Y年%m月%d日')
#  end  

#  def month_day(lang='zh')
#    strftime('%m月%d日')
#  end  
  
#  def hour_minute(lang='zh')
#    #strftime('%H点%M分')
#    hour_minute_short
#  end

#  def hour_minute_short
#    strftime('%H:%M')
#  end

#  def hour_minute_second
#    strftime('%H点%M分%S秒')
#  end
  
  ##
  def distance_to(sometime, lang='zh')
    return "" if sometime == nil
    if lang == 'zh'
      ago = '前'
      later = '后'
    else
      ago = ' ago'
      later = ' later'
    end 
    is_future = sometime > self
    seconds = is_future ? sometime - self : self - sometime
    decorate = is_future ? later : ago
    years = (seconds / YEARS).to_i
    return format_unit(years, '年', lang) + decorate unless years == 0
    months = (seconds / MONTHS).to_i
    return format_unit(months, '月',lang) + decorate unless months == 0
    days = (seconds / DAYS).to_i
    return format_unit(days, '天',lang) + decorate unless days == 0
    hours = (seconds / HOURS).to_i
    return format_unit(hours, '小时',lang) + decorate unless hours == 0
    minutes = (seconds / MINUTES).to_i
    return format_unit(minutes, '分钟',lang) + decorate unless minutes == 0
    format_unit(seconds.to_i + 1, '秒',lang) + decorate
  end
  
 
#  def self.duration(seconds)
#    if seconds == 0
#      '0秒'
#    else
#      original = Duration.new(seconds).to_s
#      original.gsub(/weeks?/, '周').gsub(/days?/, '天').gsub(/hours?/, '小时').gsub(/minutes?/, '分').gsub(/seconds?/, '秒').delete(', and')
#    end    
#  end
  
#  def self.duration_between(begin_time, end_time)
#    self.duration(end_time - begin_time)
#  end
  
#  def duration_to(sometime)
#    if self == sometime
#      "现在"
#    else 
#      if self < sometime
#        Time::duration(sometime - self) + "后"
#      else
#        Time::duration(self - sometime) + "前"        
#      end
#    end
#  end

  # make a Time from string such as Sat Jun 06 09:23:11 +0000 2009
  def self.from_str(str)
    a = str.split
    b = a[3].split(":")
    Time.utc(a[5],a[1],a[2],b[0],b[1],b[2])
  end

private
  def format_unit(quantity, chinese_unit, lang)
    en_units = {'年' => 'year', '月' => 'month', '天' => 'day', '小时' => 'hour', '分钟' => 'minute', '秒' => 'second'}
    if lang == 'zh'
      return "#{quantity}#{chinese_unit}"
    else
      return "#{quantity} #{en_units[chinese_unit]}#{'s' if quantity > 1}"
    end
  end

end
  