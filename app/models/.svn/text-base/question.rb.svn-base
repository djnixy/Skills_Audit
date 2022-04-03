# Model for Questions table. Stores question id, xml data, depreciated boolean
# and contains functions to access and manipulate this data.
class Question < ActiveRecord::Base
  has_one :exam_question
  has_many :exams, :through => :exam_questions
  has_many :results
  
  belongs_to :master_question,
             :class_name => "Question",
             :foreign_key => "master_id"
           
  has_many   :slave_questions,
             :class_name => "Question",
             :foreign_key => "master_id"
  
  def make(q_category, q_subcategory, q_type, q_text)
    doc = REXML::Document.new
    root = doc.add_element "question"
    root.attributes["category"] = q_category
    root.attributes["subcategory"] = q_subcategory
    qtype = root.add_element "qtype"
    qtype.text = q_type
    qtext = root.add_element "qtext"
    qtext.text = q_text
    qamount = root.add_element "qamount"
    qamount.text = "0"
    asw = root.add_element "asw"
    asw.text = "0"
    weight = root.add_element "weight"
    self.q_data = root.to_s
    self.depreciated = false
    self.save
  end
  
  def add_choice(choicetext)
    logger.debug("addchoice("+choicetext.to_s+")")
    doc = self.get_xml
    q = doc.root.add_element "q"
    q.text = choicetext
    q.attributes["id"] = (doc.root.elements['qamount'].text.to_i + 1).to_s
    doc.root.each_element("//qamount") { |e| e.text = e.text.to_i + 1 }
    self.q_data = doc.root.to_s
    self.save
  end
  
  def get_subcategory
    logger.debug("get_subcategory("+id.to_s+")")
    doc = get_xml
    doc.root.attributes["subcategory"].to_s
  end
  
  def get_category
    logger.debug("get_category("+id.to_s+")")
    return self.question_type
  end
  
  def get_weight
    logger.debug("get_weight("+id.to_s+")")
    doc.each_element("//q_weight") do |e|
      return e.text.to_i
    end
  end
  
  # gets summary information from question xml for teacher view
  def get_summary
    logger.debug("get_summary("+id.to_s+")")
    doc = get_xml
    doc.each_element("//qsummary") do |e|
      return e.text.to_s
    end
  end
  
  def self.find_all_by_subcategory_and_exam_id(subcat, exam_id)
    logger.debug("find_all_by_subcategory_and_exam_id(#{subcat.to_s}, #{exam_id.to_s})")
    questions = Exam.find_by_id(exam_id).questions.find(:all)
    output = Array.new
    for q in questions
      if q.get_subcategory == subcat
        output.push(q)
      end
    end
    return output
  end
  
  def set_answer(choice_id)
    doc = get_xml
    doc.root.elements['asw'].text = choice_id
  end
  
  # returns XML file from database corresponding to question_id
  def get_xml
    logger.debug("get_xml("+id.to_s+")")
    xml_data = q_data
    doc = REXML::Document.new( xml_data )
    doc
  end

  # returns question string.
  def get_question
    logger.debug("get_question("+id.to_s+")")
    doc = get_xml
    doc.each_element("//qtext") do |e|
      return e.text.to_s
    end
  end
  
  def get_sub_id_text(part_id)
    logger.debug("get_sub_id_text("+part_id.to_s+")")
    doc = get_xml
    a = Array.new
    doc.each_element("//q[@id='#{part_id}']") do |e|
      a.push(e.text.to_s)
    end
    logger.debug("array: " + a.inspect)
    return a
  end
  


  # returns string corresponding to choice_id
  def get_choice( choice_id )
    logger.debug("get_choice("+choice_id.to_s+")")
    doc = get_xml
    doc.each_element("//q") do |e|
      if e.attributes["id"].to_i == choice_id.to_i
        return e.text.to_s
      end
    end
    return "Not Answered"
  end
  
  # returns a 'part' of a question. Use is multitype questions such as word match.
  def get_q_part(part_type, part_id)
    logger.debug("get_q_part("+part_type.to_s+","+part_id.to_s+")")
    doc = get_xml
    doc.each_element("//q[@id='#{part_id}']") do |e|
      logger.debug(e.inspect)
      if e.attributes["type"] == part_type
        return e.text.to_s unless e.nil?
      end
    end
  return :no_match
  end
  
  def get_subid_count(q_id)
    logger.debug("get_subid_count("+id.to_s+", q_id:"+q_id.to_s+")")
    doc = get_xml
    count = 0
    doc.each_element("//q") do |e|
      count += 1 if e.attributes["subid"].to_i == q_id.to_i
    end
    return count
  end
  
    def get_id_count()
    logger.debug("get_id_count("+id.to_s+")")
    doc = get_xml
    count = 0
    doc.each_element("//q") do |e|
      count += 1
    end
    return count
  end
  
  def get_last_id
    doc = get_xml
    last = 0
    doc.each_element("//q") do |e|
      last = e.attributes["id"].to_i #if e.attributes["id"].to_i != last
    end
    return last
  end
  
  # returns number of choices in a given question as integer
  def get_choice_amount
    logger.debug("get_choice_amount("+id.to_s+")")
    doc = get_xml
    doc.each_element("//qamount") do |e|
      return e.text.to_i
    end
  end
  
  # Returns answer dependant on question type. Multiple choice checks the choice
  # corresponding to the answer number and returns that as a string. Single 
  # answer question returns string containing answer.
  def get_answer
    logger.debug("get_answer("+id.to_s+")")
    doc = get_xml
    doc.each_element("//asw") do |e|
      case get_type
      when :multiple, :true_false
        return get_choice(e.text.to_i)
      when :spelling
        return e.text.to_s
      else
        return e.text.to_s
      end
    end
  end
  
  def get_multi_type
    logger.debug("get_multi_type("+id.to_s+")")
    doc = get_xml
    doc.each_element("//qtype") do |e|
      unless e.attributes["multipart"].nil?
        if e.attributes["multipart"] == "master"
          logger.debug("multipart_master")
          return :master
        else
          logger.debug("multipart_slave")
          return :slave
        end
      else
        logger.debug("not_multi")
        return :not_multi
      end
    end
  end
  
  def get_master
    return self.master_id
  end
  
  #Returns question type
  def get_type
    doc = get_xml
    doc.each_element("//qtype") do |e|
      case e.text
      when "Multiple Choice"
        return :multiple
      when "True False"
        return :true_false
      when "Word Match"
        return :word_match
      when "Sequence"
        return :sequence
      when "Arrange Alphabetical"
        return :arrange_alpha
      when "Arrange Order"
        return :arrange_order
      when "Fill in Blanks"
        return :blanks
      when "Select Wrong Word"
        return :wrong_word
      when "Long Answer"
        return :long_answer
      when "Short Answer"
        return :short_answer
      when "Spelling"
        return :spelling
      when "Calculation"
        return :calculation
      when "Multiple Short Answer"
        return :multi_short
      when "Multipart"
        return :master
      else
        return :not_found
      end
    end
  end
  
  #
  def needs_submit
    case get_type
    when :long_answer
      return true
    when :arrange_order, :sequence, :arrange_alpha, :word_match, :master,:spelling
      return false
    else
      return true
    end
  end
  
  #
  def show_question_text
    if show_question?
      case get_type
      when :spelling
        
      end
    end
  end
  
  #
  def show_question
    case get_type
    when :blanks
      return false
    else
      return true
    end
  end
  
  #
  def display_details
    return "question id: " + id.to_s + ", choices: " + get_choice_amount.to_s + ", depreciated: " + depreciated.to_s + ", type: " + get_type.to_s
  end

end