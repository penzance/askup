class Qset < ActiveRecord::Base
  has_many :questions
  has_many :members, class_name: 'User', foreign_key: 'org_id'
  validates_presence_of :name
  acts_as_tree order: :name

  qset_defaults = Rails.configuration.askup.defaults.qset
  has_settings do |s|
    s.key :permissions, :defaults => {
        :all_questions_visible => qset_defaults.all_questions_visible,
        :question_authors_visible => qset_defaults.question_authors_visible,
        :questions_visible_to_unauth_user => qset_defaults.questions_visible_to_unauth_user,
        :qset_type => qset_defaults.qset_type
    }
  end

  # todo: this overwrites any changes made before a new Qset is saved; try to make it work for before_create?
  after_create :inherit_permissions
  before_destroy :prevent_root_node_destroy
  after_destroy :move_orphans_to_parent

  # update_permissions() expects the argument `permissions` to be a hash
  # mapping permission names (symbols) to new permission values.
  # If with_descendants is `true` then it will update all subsets of this qset as well.
  def update_permissions(permissions, with_descendants=false)
    self.settings(:permissions).update_attributes! permissions
    if with_descendants
      self.descendants.each do |q|
        q.update_permissions permissions
      end
    end
  end

  def is_destroyable?
    self.children.empty? or self.root?
  end

  def to_s
    self.to_json
  end

  def self.contains_questions(qset_id)
    qsets_containing_questions = []
    Qset.find(qset_id).descendants.each do |a| 
      # filter out qsets that only contain subsets
      if a.settings(:permissions).qset_type != 'subsets'
        qsets_containing_questions << a
      end
    end

    return qsets_containing_questions
  end


  private
  def inherit_permissions
    unless self.root?
      my_perms = self.settings(:permissions)
      parent_perms = self.parent.settings(:permissions)
      my_perms.all_questions_visible = parent_perms.all_questions_visible
      my_perms.question_authors_visible = parent_perms.question_authors_visible
      my_perms.questions_visible_to_unauth_user = parent_perms.questions_visible_to_unauth_user
      self.save!
    end
  end

  def prevent_root_node_destroy
    if self.root?
      false
    end
  end

  # when a Qset is destroyed, instead of destroying
  # all Questions (and Answers) in that group, move them to
  # the parent group; note that we should not be able to destroy
  # a Qset without a parent (see :prevent_root_node_destroy)
  def move_orphans_to_parent
    orphan_questions = Question.where(qset_id: self.id)
    orphan_questions.update_all(qset_id: self.parent.id)
  end
end
