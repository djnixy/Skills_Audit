# Provides various methods for manipulating an exam (both in progress and not)
class Exam < ActiveRecord::Base
  belongs_to :teacher
  has_many :student_exams, :dependent => :destroy
  has_many :questions, :through => :exam_questions
  validates_presence_of   :name
  #validates_uniqueness_of :name
  has_many :exam_questions
  
  # Gets the next question and returns either its id as an integer or 1 (exam_end)
  def get_next_q( prev_q_id )
    a = self.questions.find(:all)
    b = self.questions.find_by_id(prev_q_id)
    a.each_index { |q|
      if a[q-1].id == b.id
        if a[q].id.to_i
          return a[q].id.to_i
        else
          return 1
        end
      end
    }
    return 1
  end
  
  def get_next_q_ex( prev_q )
    logger.info(prev_q.inspect)
    eq_pos = ExamQuestion.find_by_exam_id_and_question_id(self.id, prev_q.id).position.to_i
    eq = ExamQuestion.find_by_exam_id_and_position(self.id, eq_pos+1)
    logger.info(eq.inspect)
    unless eq.nil?
      return (eq_pos+1).to_i
    else
      return 0
    end
  end
  
  def make(options={:e_results_viewable=>1, :e_status=>1, :e_skippable=>1})
    self.name = options[:e_name]
    self.results_viewable = options[:e_results_viewable]
    self.status = options[:e_status]
    self.skippable = options[:e_skippable]
    self.exam_type = options[:exam_type]
    self.save
  end
  
  #Add question to the current exam
  def add_question(question, options={})
    eq_all = Array.new(ExamQuestion.find_all_by_exam_id(self.id, :order => 'position asc'))
    eq = ExamQuestion.new
    eq.exam_id = id
    eq.question_id = question
    unless options[:first]
      eq.position = eq_all.last.position + 1 
    else
      eq.position = 0
    end
    eq.save
  end
  
  def add_multipart(master_id)
    m = Array.new(Question.find_all_by_master_id(master_id))
    add_question(master_id)
    m.each {|s| add_question(s.id)}
  end
  
  # returns question object matching id question_id (shortcut method)
  def add_by_id(question_id)
    return Question.find_by_id(question_id)
  end
  
  # Gets and returns the first exam question's id as an integer.
  # Assumes first question in exam is question_id 1 (exam_end)
  def get_first_q
    a = self.questions.find(:all)
    return a[1].id.to_i
  end
  
  def get_first_q_ex
    return 1
  end
  
  #NEED TO BE FIXED: Basic implementation of getting the previous question.
  def get_prev_q( current_q )
    a = self.questions.find(:all)
    for q in a
      if ( q.id ) == current_q.id
        return q - 1
      end
    end
  end
  
  def get_prev_q_ex( prev_q, position )
    logger.info(prev_q.inspect)
    #eq_pos = ExamQuestion.find_by_exam_id_and_question_id(self.id, prev_q.id).position.to_i
    eq_pos = position.to_i
    eq = ExamQuestion.find_by_exam_id_and_position(self.id, eq_pos-1)
    logger.info(eq.inspect)
    logger.debug(eq_pos.inspect)
    unless eq.nil? || eq.id == 0 || eq_pos-1 == 0
      
      return (eq_pos-1).to_i
    else
      return 1
    end
  end
  
  def get_summary()
    all_questions = self.questions.find(:all)
    question_amount = 0
    for q in all_questions
      question_amount += 1 unless q.get_multi_type == :master
    end
    return question_amount
  end
  
  def get_name
    return name
  end
  
  def get_subcategories
    categories = []
    all_questions = self.questions.find(:all)
    for q in all_questions
      unless categories.find {|i| i == q.get_subcategory}
        categories.push(q.get_subcategory) unless q.get_subcategory == ""
      end
    end
    logger.debug("categories: " + categories.join(','))
    categories.delete_at(0)
    return categories
  end
  
  #Returns a string providing exam id and status code.
  def display_details
    return "exam id: " + id.to_s + ", status: " + status.to_s
  end
end
