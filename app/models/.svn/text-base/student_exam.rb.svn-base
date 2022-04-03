class StudentExam < ActiveRecord::Base
  belongs_to :student
  belongs_to :exam
  has_many :results
  
  def exam_in_progress(question_id)
    self.status = 2 if self.status == 1
    self.attempt_position = question_id
  end

  #If it is the end of exam, set the status to 3 (Finished) then save.
  def end_exam
    self.status = 3
    self.save  
  end
  
  def score
    s = self.results
    x = 0
    s.each {|e| x += e.score.to_i unless e.nil?}
    return x
  end
  
  def get_exam_information
    return exam.name #+ "("+exam_id.to_s+","+id.to_s+")" FOR DEBUGGING
  end

  def display_details
    r = "student_exam id: " + id.to_s + ", student id: " + student_id.to_s
    r += ", exam id: " + exam_id.to_s + ", status: " + status.to_s
    return r
  end
end
