class WikiPage < ActiveRecord::Base
  # --- 模型关联
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :product, :class_name => 'Product'

  # 多态
  belongs_to :from_model, :polymorphic => true

  # --- 版本控制
  audited

  # --- 校验方法
  validates_format_of :title, 
    :with    => WikiPageFormatter::TITLE_REGEXP,
    :message => '词条标题不允许特殊字符'

  validates_uniqueness_of :title, :message => '词条标题不能重复'

  before_validation :validate_unique_of_from_model, :unless => Proc.new { self.from_model.blank? }
  def validate_unique_of_from_model
    if WikiPage.where(:from_model_id => self.from_model_id, :from_model_type => self.from_model_type).exists?
      return false
    end
  end


  validates :title,   :presence => true
  validates :product, :presence => true
  validates :creator, :presence => true

  attr_accessor :preview

  # 在词条校验之前，调整标题信息，使得各种标题都符合合法格式
  before_validation :fix_title
  def fix_title
    self.title = '无标题' if self.title.blank?

    # 第一步，替换非法字符
    self.title = self.title.gsub(WikiPageFormatter::TITLE_INVALID_CHAR_REGEXP, '-')

    # 第二步，去掉多余不必要空格
    self.title = self.title.strip.gsub(/\s+/, ' ')

    return true if @preview
    
    # 第三步，增加时间戳来避免标题重复
    while self.is_title_repeat? do
      self.title = "#{self.title}-#{Time.now.strftime '%Y-%m-%d-%H-%M-%S'}"
    end
  end

  
  # 保存到数据库后，把引用url存到表里面
  after_save :refresh_refs

  def refresh_refs
    # 先删除所有之前的ref记录
    WikiPageRef.destroy_all(:product_id => self.product_id, :from_page_title => self.title)

    if !self.content.blank?

      to_page_titles = []

      self.content.each_line do |line|
        match = line.match WikiPageFormatter::TITLE_REF_REGEXP
        if match
          to_page_titles << match[1]
        end
      end


      to_page_titles.uniq.each do |to_page_title|
        WikiPageRef.create(
          :product         => self.product,
          :from_page_title => self.title,
          :to_page_title   => to_page_title
        )
      end
    end
  end



  # 生成 wiki page 动态
  after_create :generate_create_activity
  after_update :generate_update_activity

  def generate_create_activity
    Activity.create(
      :product => self.product,
      :actor => self.creator,
      :act_model => self, 
      :action => 'CREATE_WIKIPAGE'
    )
  end

  def generate_update_activity
    Activity.create(
      :product => self.product,
      :actor => self.creator,
      :act_model => self, 
      :action => 'UPDATE_WIKIPAGE'
    )
  end



  # 判断词条标题是否重复·
  def is_title_repeat?
    x = WikiPage.find_by_title(self.title)

    return !x.blank? && x.id != self.id
  end

  def formatted_content
    # wiki_page_formatter.rb 代码位于 /lib/wiki
    WikiPageFormatter.format(self)
  end

  def formatted_content_for_show
    str = formatted_content
    return '<div class="quiet">词条还没有内容</div>'.html_safe if str.blank?
    return str
  end

  def formatted_content_for_preview
    str = formatted_content
    return '<div class="quiet">词条还没有内容</div>'.html_safe if str.blank?
    return str
  end

  # 回滚内容状态到指定的版本  
  def rollback_to(audit)
    if audit.auditable != self
      raise '你不能回滚到一个不属于本词条的版本记录'
    end

    audit_content = case audit.action
      when 'create'
        audit.audited_changes['content']
      when 'update'
        audit.audited_changes['content'].last
    end

    self.content = audit_content
    self.save
  end

  def split_section(section_num)
    WikiPageFormatter.split_section(self, section_num)
  end


  def self.save_new_draft(current_user, drafted_hash, temp_id = nil)
    if temp_id.nil?
      temp_id = randstr()
      drafted_hash[:temp_id] = temp_id
      drafted_hash = Marshal.dump(drafted_hash)

      Draft.create(
        :creator => current_user,
        :temp_id => temp_id,
        :model_type => "WikiPage",
        :drafted_hash => drafted_hash
      )

    else
      drafted_hash[:temp_id] = temp_id
      drafted_hash = Marshal.dump(drafted_hash)

      draft = Draft.find_by_temp_id(temp_id)
      draft.drafted_hash = drafted_hash
      draft.save
    end

    temp_id
  end


  def save_draft(current_user, drafted_hash)
    drafted_hash = Marshal.dump(drafted_hash)

    saved_draft = Draft.where(:model_id => self.id, :model_type => self.class.name).exists?

    unless saved_draft
      Draft.create(
        :creator => current_user,
        :model => self,
        :drafted_hash => drafted_hash
      )
    else
      draft = Draft.where(:model_id => self.id, :model_type => self.class.name).first
      draft.drafted_hash = drafted_hash
      draft.save
    end

  end



  # 引用其它类
  include Activity::ActivityableMethods


  
  # --- 给其他类扩展的方法
  module WikiPageableMethods
    def self.included(base)
      base.has_many :wiki_pages, :as => :from_model
    end
  end


  module UserMethods
    def self.included(base)
      base.has_many :wiki_pages, :foreign_key => :creator_id
    end
  end

  # -------------- 这段需要放在最后，否则因为类加载顺序，会有警告信息
  # 设置全文索引字段
  # define_index do
  #   # fields
  #   indexes title, :sortable => true
  #   indexes content
  #   indexes product_id
    
  #   # attributes
  #   has created_at, updated_at

  #   set_property :delta => true
  # end

end
