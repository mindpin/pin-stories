class RedisDatabase
  # DB 只能取 0 - 15 这十六个数字之一
  
  if Rails.env.test?
    TIP_DB   = 8
    QUEUE_DB = 9
    CACHE_DB = 10
  else
    TIP_DB   = 0
    QUEUE_DB = 1
    CACHE_DB = 2
  end

  def self.get_db_instance(db)
    if $REDIS_NAMESPACE.blank?
      raise NoRedisNameSpaceError.new('没有设置 $REDIS_NAMESPACE 常量，请在 application.rb 里设置') 
    end

    redis = Redis.new(:thread_safe => true)
    redis.select(db)

    app_redis = Redis::Namespace.new($REDIS_NAMESPACE, :redis => redis)
    return Redis::Namespace.new(self.to_s, :redis => app_redis)
  end

  class NoRedisNameSpaceError < Exception; end;
end
