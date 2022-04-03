module StudentHelper
   
  def sortable_data(question, options={:div_id => 'result', :tag=>:li, :type=>:ul})
    div = options[:div_id].to_s || "result"
    tag = options[:tag]
    type = options[:type]
    items = ""
    items +="<#{type} id='#{div}'>" if tag == :li
      i = 0; x = question.get_choice_amount; until i == x
        if options[:q_part]
          unless question.get_q_part(options[:q_part], i+1) == :no_match
            items += "<#{tag} class='ddlist' id='item_#{i+1}'>#{question.get_q_part(options[:q_part], i+1)} </#{tag}>"
          end
        else
          items += "<#{tag} class='ddlist' id='item_#{i+1}'>#{question.get_choice(i+1)} </#{tag}>"
        end
        items += "<"+options[:seperator]+">" if options[:seperator]
        i += 1
      end
    items+="</#{type}>" if tag == :li
    div = div + "_div" if tag == :li
    return "<div id='#{div}'>"+ items + "</div>"
  end
  
  
  def sortable_submit(form, amount, hidden_element)
    return form.submit('Next Question', :class => "submit",  :onclick => "writedd(\"#{amount}\",'#{hidden_element}')")
  end
  
  def spell_submit(form)
    return form.submit('Next Question', :class => "submit",  :onclick => "return spellmit()")
  end
  
  def multi_text_field(form, question, options={:textsize=>25, :format=>:table, :order=>:none, :border=>1, :align=>'right'})
    output = ""
    output += "<table border='#{options[:border]}'>\n" if options[:format] == :table
    i = 0; x = question.get_choice_amount; until i == x
      text = form.text_field :answer, :class => "textfield", :size => options[:textsize].to_i, :index => i
      choice = question.get_choice(i+1)
      if options[:order] == :choice_field
          if options[:format] == :table
            output += "<tr><td align='right'>" + choice + "</td><td>" + text + "</td></tr>\n"
          elsif options[:format] == :newline
            output += "<p>" + choice + "<br />" + text + "</p>"
          else
            output += choice + text
          end
        else
          output += text + choice
      end
      if options[:seperator]
        output += "<"+options[:seperator]+ ">\n"
      else
        output += ""
      end
      i +=1
    end
    output += "</table>\n" if options[:format] == :table
    return output
  end
  
  def multi_radio_buttons(form, question, options={:span_class=>"questionChoice"})
    output = ""
    i = 0; x = question.get_choice_amount; until i == x
      output += form.radio_button :answer, i+1
      output += "<span class='#{options[:span_class]}' onclick='rbtclick(#{i+1})'>"
      output += question.get_choice(i+1) + "</span>"
      if options[:seperator]
        output += "<"+options[:seperator]+ ">\n"
      else
        output += "<br />\n"
      end
      i += 1
    end
    return output
  end
  
  #Submit button output  
  def submit_button(form, question, options={})
    output = ""
    if question.needs_submit
      output += form.submit 'Next Question', :class => "submit"
    else
      if options[:sortable]
        output += sortable_submit form, question.get_choice_amount, 'result'
      elsif options[:no_js]
        output += form.submit 'Next Question', :class => "submit"
      elsif options[:multitype]
        output += button_to "Next Question", {:action=>:answer, :skip=>:true, :question_id => options[:multitype]}, :class=>'submit'
      elsif options[:spelling]
        output +=spell_submit form
      end
    end
    return output
  end
  
  #Skip button , confirm after button clicked
  def no_answer_button(form, st_exam, question, options={:type=>:radio, :text=>:skip}) 
    output = ""
    span = "<span class='skip'>I dont know the answer.</span>"
    unless st_exam.exam.skippable == false
      case options[:type]
      when :radio
        output = form.radio_button(:answer, 0) + span
      when :link
        output = link_to span, :action=>:answer, :result=>0, :question_id => question.id
      when :skip
        output += "</form>"
        output += button_to options[:text], {:action=>:answer, :skip=>:true, :question_id=>question.id }, :confirm => "Do you want to skip this question?", :class=>"submit"
      when :none
        output = ""
      else
        output = form.radio_button(:answer, 0) + span
      end
    end
    return output
  end
  
  
  def blanks_fields(form, question)
    output = ""
    split_q = question.get_question.split(/%%%/)
    i = 0; until i == split_q.length
      output += split_q[i] + " "
      output += form.text_field :answer, :index => i 
      i += 1 
    end
    return output
  end
  
  def master_question_text(question)
    output = ""
    if question.get_multi_type === :slave
      output += "<hr />"
      output += "<div id='master'>"
      output += question.master_question.get_question
      output += "</div>"
    end
    return output
  end
  
  def question_text(question)
    if question.show_question
      output = ""
      unless question.get_type == :spelling
        if question.get_multi_type == :slave
          output += "<div id='question_slave'><h2>Question</h2><p id='question_text'>"
        else
          if question.get_multi_type == :master
            output +="<div id='question_master'>"
          else
            output += "<div id='question'><p id='question_text'>"
          end
          
          #output += "<div id='question'><p>"
        end
        output += question.get_question
       output += "</p>"
       #  output += "</p></div>"
      end
      return output
    else
      return ""
    end
  end
  
  def question_text_end(question)
    if question.show_question
      output = ""
      unless question.get_type == :spelling
        if question.get_multi_type == :slave
          output += "</div>"
        else
          output += "</div>"
        end
        
      end
      return output
    else
      return ""
    end
  end
   
  def spelling_form(question, options={})
    output = ""
    i = 1
    x = 0
    length = question.get_last_id
    length += 1
    output +="<input type='hidden' id='questionAmount' value='#{question.get_last_id}' />"
    output+="<table class='spell_table'>"
    #output+="<table><tr>"
    
    until i == length
    #until i == question.get_last_id
      #until i == question.get_id_count
        output+="<tr class='spell_table'>"
      subtext_array = question.get_sub_id_text(i)
      #logger.info(question.get_id_count)
      logger.info(subtext_array)
      
      for s in subtext_array
      output+="<td class='spell_row'>"
        logger.info("subtext: " + s.inspect)
        if options[:text]
          output += link_to s, "#", :onclick=>"spelling(#{i}, #{s});"
        else
         # output += button_to s, "", :onclick=>"spelling(#{i+1}, #{s});"
        output += "<span id='#{s}' onclick='spelling(#{i}, \"#{s}\",\"#{s}\")' > #{s}</span>"
        output+="</td>"
        end
        x += 1 
        
      end
      #output+="</tr><tr>"
      output+="</tr>"
      i += 1
    end
    output+="</table>"
    output += "<script type='text/javascript'>"
    output +=" onload=spellLoad()"
    output +="</script>"
    return output
    
  end
  
  #Show the help text above the questions
  #Get the question type and output the appropriate help text  
  def help_text(question)
    output =""
    output +="<div id='help_text'><p>"
    case question.get_type
    when :wrong_word
      output +="Which one is WRONG? Click on the wrong answer."
    when :multiple
      output +="Choose the correct answer."
    when :master
      output +="Read the passage and then answer the questions which follow."
    when :sequence
      output +="Put these in the right order. Click and drag left ot right."
    when :true_false
      output +="True or false?"
    when :word_match
      output +="Match the word on the right with the definition on the left. Click and drag the words up or down."
    when :arrange_alpha
      output +="Put these in alphabetical order. Click and drag up or down."
    when :arrange_order
      output +="Click and drag the words/statements inside the box into the correct order, first is at the top and last at the bottom."
    when :blanks
      output +="Fill in the missing words inside the text boxes."
    when :wrong_word
      output +="Select the word that is incorrect from the choices."
    when :long_answer, :short_answer
      output +="Type the answer in the box."
    when :spelling
      output +="Which spelling is correct? Click on the correct word in each row."
    when :calculation
      output +="Put an answer in each box"
    when :multi_short
      output +="Put an answer in each box"
    end
    output +="</p></div>"
    return output
  end
  
  def hidden_fields(question)
    output = ""
    case question.get_type
    when :arrange_order, :arrange_alpha, :spelling
      logger.info("hidden_field")
      output += hidden_field "result", :answer
    when :multiple, :master, :true_false
      logger.info("skip_field")
      output += hidden_field "skip", :selection
    else
      output += ""
    end
    return output
  end
  
  #Exam summaries, showing the exam name the student is on, and the question number
  def exam_summary(exam, position)
    output = ""
    output += "<p class='test_summary'>You are currently on exam: " + exam.name.to_s + "<br />\n"
    output += "You are on question <b>" + position.to_s + "</b> of <b>" + (exam.get_summary).to_s + "</b></p><br />\n"
    return output
  end
  
  
  def exam_master(exam, position)
    output = ""
    output += "You are currently on exam: " + exam.name.to_s + "<br />\n"
    output += "This exam has <b>" + ((exam.get_summary)-position.to_i).to_s + "</b> questions left"
  end
end