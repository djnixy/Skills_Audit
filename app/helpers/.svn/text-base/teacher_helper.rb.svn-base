module TeacherHelper
 
  
  #Checks the id's of all questions against the id's of questions in the exam 
  #and displays the question if it is not in the test
  def question_list(question)
    
    output =""
    count = 0 

      i = 0; until i == @exam_questions.length 
        if @questions[question].id == @exam_questions[i].id 
          count += 1  
        end 
        i +=1 
      end 
        
      if count == 0 
          output +=  " <div id='item_#{@questions[question].id}'> #{render :partial => 'question_add', :object => @questions[question]}<br /></div>" 
      end 
  end
  

  def mark_box(result)
    output = ""
    enabled = false
    enabled = true unless result.get_score.to_i <= 0 unless result.get_score.nil?
    output += check_box_tag 'r_mark[]', result.id, enabled
    return output
  end
  
  def bar(mark)
    output = ""
    output += image_tag "/images/bar.PNG", :width=>6*mark
    return output
  end

  def list_text(question)
    output =""
    #output +="<div id='help_text'><p>"
    case question.get_type
    when :wrong_word
      output +="Wrong Word"
    when :multiple
      output +="Multiple Choice"
    when :master
      output +="Read the passage below and then answer the questions which follow."
    when :sequence
      output +="Order Sequence"
    when :true_false
      output +="True or False"
    when :word_match
      output +="Word Match."
    when :arrange_alpha
      output +="Arrange Alphabetically"
    when :arrange_order
      output +="Arrange Order."
    when :blanks
      output +="Fill in the blanks."
    when :wrong_word
      output +="Select the wrong word."
    when :long_answer, :short_answer
      output +="Write a text response."
    when :spelling
      output +="Select the correct word spelling."
    when :calculation
      output +="Calculate the correct amount."
    end
    #output +="</p></div>"
    return output
  end
  
 #
  def exam_submit(button_text,exam_id)
    output = ""
    if StudentExam.find_by_exam_id(exam_id)== nil
      output += submit_tag "#{button_text}", {:onclick => "return examdd(" + ((@questions.length-1) + (@exam_questions.length)).to_s + ", 'exam2')"}
   else
      output += submit_tag "#{button_text}", {:onclick => "return examdd_warn(" + ((@questions.length-1) + (@exam_questions.length)).to_s + ", 'exam2')"}
    end
    return output
  end
  
end


