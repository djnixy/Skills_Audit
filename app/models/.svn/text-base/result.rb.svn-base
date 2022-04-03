# Student results are held in this table. Model implements functions to find and
# review answers.
# TO DO: Fix format_answer assumptions
class Result < ActiveRecord::Base
  belongs_to :student_exam
  belongs_to :question
  
  validates_presence_of :answer
  validates_uniqueness_of :question_id, :scope => :student_exam_id
  
  # Returns student's answer dependant on question type. Multiple choice checks 
  # the choice corresponding to the answer number and returns that as a string.
  # Single answer question returns string containing answer.
  def get_answer
    x = self.question.get_type
    case x
    when :multiple, :true_false
      return self.question.get_choice(answer).to_s
    when :word_match
      return self.answer.to_s
    when :sequence
      return self.answer.to_s
    when :arrange_alpha
      return self.answer.to_s
    when :arrange_order
      return self.answer.to_s
    when :blanks
      return self.answer.to_s
    when :wrong_word
      return self.answer.to_s
    when :long_answer
      return self.answer.to_s
    when :short_answer
      return self.answer.to_s
    when :spelling
      return self.answer.to_s
    when :calculation
      return self.answer.to_s
    when :multi_short
      return self.answer.to_s
    else
      return "Not Answered"
    end
  end
  
  # Finds a result corresponding to foreign keys question_id and student_exam_id 
  # and returns it as a result object.
  def self.find_result( question, studentexam )
    find(:first, :conditions => { :question_id => question, :student_exam_id => studentexam })
  end
  
  def skipped_question?(skip, result)
    #logger.info(skip.inspect)
    #logger.info(result.inspect)
    #if skip == "true"
    #  return "0"
    #else
    #  return answer
    #end
    
    logger.info(skip.inspect)
    logger.info(result.inspect)
    if skip == "true"
      return 1
    else
      return 0
    end
  end
  
  def format_answer(a)
    b = a 
    logger.info(b.class)
    if b.kind_of?(Hash)
      c = b["answer"]
      logger.info(c.class)
      logger.info(c.inspect)
      if c == nil
        # assuming b key == result. fix when able
        st = ""
        i = 0; until i == b.length
          unless b.values_at(i.to_s)[0].values_at("answer")[0].nil? || b.values_at(i.to_s)[0].values_at("answer")[0] == ""
            st += b.values_at(i.to_s)[0].values_at("answer")[0]            
            st += "," unless i == b.length - 1
            i += 1
          else
            return ""
          end
        end
        return st
      elsif c.class == Array
          return c.join(",")
      elsif c.class == String
        c_array = c.split(',')
        for d in c_array
          if d == "" || d.nil?
            return ""
          end
        end
        return c_array.join(",")
      elsif c.class == Fixnum
          return c
      else
        return c
      end
    elsif b.class == Array
      return b.join(",")
    elsif b.class == String
      b_array = b.split(',')
      for e in b_array
        if e == "" || e.nil?
          return ""
        end
      end
      return b_array.join(",")
    elsif b.class == Fixnum
      return b
    end
  end
  
  def revert_answer_format
    if self.question
      case self.question.get_type
      when :multiple, :true_false
        return answer.to_i
      when   :blanks, :wrong_word, :calculation, :multi_short, :long_answer, :short_answer
        return answer.split(',')
      when :spelling , :word_match, :sequence,:arrange_order, :arrange_alpha
        return answer.split('|')
      end
    end
  end
  
  def save_result( prev_q, next_q, skip )
    if prev_q.id == 1
        return :end
    elsif self.save
        unless next_q.id == 1
          return :next_question
        else
          return :end
        end
    else
        if skip == "true"
          if next_q.id == 1
            return :end
          else
            return :skipped
          end
        elsif self.answer.nil?
          return :no_answer_nil
        elsif self.answer.strip == ""
          return :no_answer_spaces
        else
          unless next_q.id == 1
            return :update_next
          else
            return :update_end
          end
        end
    end
  end
  
  def get_score
    return self.score
  end
  
  # checks if a questions is correct and returns "correct" or "incorrect". Currently
  # designed for view display css classes.
  def is_correct
    case question.get_type
    when :multiple, :true_false
      if question.get_answer.upcase == get_answer.upcase
        return "correct"
      else
        return "incorrect"
      end
    else
      return "answer"
    end
  end

  def mark
    if question.get_category == :numeracy
      if question.get_answer.upcase == get_answer.upcase
        return question.get_weight
      else
        return 0
      end
    else
      case question.get_type
      when :multiple, :true_false
        if question.get_answer.upcase == get_answer.upcase
          return question.get_weight
        else
          return 0
        end
      else
        return 0
      end
    end
    return 0
  end
  
end