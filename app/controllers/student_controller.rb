# Student Controller
class StudentController < ApplicationController
  before_filter :authorize, :except => [:login, :logout]
  
  #layout 'student'
  def login
    session[:student_id] = nil
    session[:teacher_id] = nil
    session[:admin_id] = nil
    if request.post?
      student = Student.authenticate(params[:name], params[:password])
      teacher = Teacher.authenticate(params[:name], params[:password])
      admin = Admin.authenticate(params[:name], params[:password])
      if teacher
        logger.info("Setting session teacher")
        session[:teacher_id] = teacher.id
        redirect_to({ :controller => :teacher, :action => "index" })
      elsif student
        logger.info("setting session student")
        session[:student_id] = student.id.to_i
        uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to( uri || { :action => "introduction" } )
      elsif admin
        logger.info("Setting session admin")
        session[:admin_id] = admin.id
        redirect_to({ :controller => :admin, :action => "index" })
      else
        logger.info("Bad password")
        flash[:notice] = "Invalid User Name/Password"
      end
    end
  end
  

  # Exam view. Accepts question_id as a parameter (student/exam/x).
  # Checks student session, finds question(id), student(session),
  # student_exam(student), and creates a new Result object for manipulation.
  def exam
    @student = Student.find_by_id(session[:student_id])
    @st_exam = @student.find_exam
    @question = ExamQuestion.find_by_exam_id_and_position(@st_exam.exam.id, params[:id]).question
    @result = Result.find_by_student_exam_id_and_question_id(@st_exam.id, @question.id)

    #@result = Result.new
    logger.debug(@result.inspect) if @result
    @result = Result.new unless @result
    @st_exam.exam_in_progress(@question.id)
    @position = params[:id]
    logger.debug("position: " + @position.inspect)
    @no_question = :radio
    @submit_type = {:no_js => true}
    @skip_type = {:type => :skip, :text => 'Skip Question'}
    
    respond_to do |format|
      format.html # exam.html.erb
      format.xml  { render :xml => @question }
    end
  end

  
  def index
    redirect_to :action=>:introduction
  end
  
  # Answer is passed from Exam view and processed. Saves and proceeds to next
  # question or ends the exam. If save fails, take appropriate action.
def answer
    @student = Student.find_by_id(session[:student_id])
    @st_exam = @student.find_exam
    current_q = Question.find(params[:question_id])
    current_pos = ExamQuestion.find_by_exam_id_and_question_id(@st_exam.exam.id, params[:question_id]).position
    next_pos = @st_exam.exam.get_next_q_ex(current_q)
    @question = @st_exam.exam.exam_questions.find_by_position(next_pos).question
    logger.info(@question.inspect)
    @result = Result.new
    answer = params[:result]
    answer = "0" if answer.nil?
    if current_q.get_multi_type == :master
      answer = "Master Question"
    else
      answer = '' if params[:result].nil?
    end

    @result.skipped = "0"
    @result.skipped = "1" if params[:skip] === "true"
    if @result.skipped == "1"
      @result.answer = "Skipped"
    else
      @result.answer = @result.format_answer(answer)
    end
    @result.question_id = current_q.id
    @result.student_exam_id = @st_exam.id
    
    save_code = @result.save_result(current_q, @question, params[:skip])
    logger.info(save_code.to_s)
    respond_to do |format|
      case save_code
        when :end #if the end of exam
          format.html { redirect_to(:action => "exam_finish") }
        when :next_question, :skipped
          format.html { redirect_to(:action => :exam, :id => next_pos) }
        when :no_answer_nil, :no_answer_spaces
          flash[:notice] = "Please enter an answer!"
          format.html { redirect_to( :action => :exam, :id => current_pos ) }
        when :update_next, :update_end
          @prevresult = Result.find_result(current_q.id, @st_exam.id)
          @prevresult.answer = @result.answer
          @prevresult.save(false)
          if save_code == :update_next
            format.html { redirect_to(:action => :exam, :id => next_pos ) }
          
          else
            format.html { redirect_to(:action => "exam_end") }
          end
        else
          format.html { redirect_to(:action => "exam_end") }
      end
    end
  end
  
  def introduction
    redirect_to :controller=>:admin, :action=>:index if session[:admin_id]
    return nil if session[:admin_id]
    redirect_to :controller=>:teacher, :action=>:index if session[:teacher_id]
    return nil if session[:teacher_id]
    @student = Student.find_by_id(session[:student_id])
    logger.debug(@student.inspect)
    @introduction = 0
    unless @student.nil?
    unless @student.find_exam.nil?
      @st_exam = @student.find_exam
      @introduction = 1
    end
    end

    respond_to do |format|
      format.html # introduction.html.erb
      #format.xml  { render :xml => @question }
    end
  end
  
  def check_skipped_question
    @exam_question = Exam_Question.find(:answered)
    
    
    respond to do |format|
      format.html  #
      
    end
  end
  
  #Exam is finished. status set to 3: completed
  def exam_end
    @student = Student.find_by_id(session[:student_id])
    @st_exam = @student.find_exam
    @st_exam.end_exam
  end
  
  def results
    @student = Student.find_by_id(session[:student_id])
    @answers = @student.student_exams.find_by_id(params[:id]).results.find(:all)
  end
  
  def last_results
    @student = Student.find_by_id(session[:student_id])
    @answers = @student.find_last_completed_exam    
      if request.xhr?
        respond_to do |format|
          format.js
          format.html
        end
    end
  end
  
  def logout
    reset_session
    
    respond_to do |format|
      format.html
    end
  end
  
  
  
protected

  def authorize
    unless Student.find_by_id(session[:student_id]) || Teacher.find_by_id(session[:teacher_id]) || Admin.find_by_id(session[:admin_id])
      session[:original_uri] = request.request_uri
      flash[:notice] = "Please login with your user name and password."
      redirect_to :controller => :student, :action => :login
    end
  end
  
  def authorized?
    unless Student.find_by_id(session[:student_id]) || Teacher.find_by_id(session[:teacher_id]) || Admin.find_by_id(session[:admin_id])
      return false
    else 
      return true
    end
  end

end