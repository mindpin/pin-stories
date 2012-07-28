class UserTipMessage < RedisDatabase
  def self.instance
    @@instance ||= self.get_db_instance(RedisDatabase::TIP_DB)
  end

  def instance
    self.class.instance
  end

  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  def put(message_str, key = randstr)
    self.instance.hset self.hash_name, key, message_str
  end


  def count
    self.instance.hlen self.hash_name
  end

  def all
    self.instance.hgetall self.hash_name
  end

  def clear
    self.instance.del self.hash_name
  end

  def delete(key)
    self.instance.hdel self.hash_name, key
  end

  def path
    raise UnimplementedMethodError.new('方法需要在子类中定义')
  end

  # ----------

  def hash_name
    "user:tip:message:#{self.user.id}"
  end

  def send_count_to_juggernaut
    Juggernaut.publish self.hash_name, {:count => self.count}
  end

  class UnimplementedMethodError < Exception; end;
end
