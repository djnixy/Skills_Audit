class TeacherController < ApplicationController
  
  #User has to login first before access
  before_filter :authorize, :except => [:login, :logout]
  
  #Determine the login ID, if it's a teacher/student/admin login
  #Check for password and set the session
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
        session[:student_id] = student.id
        uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to(uri || { :action => "introduction" })
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
  
  #log out by reset_session
  def logout
    @exam = false
    reset_session
    
    respond_to do |format|
      format.html
    end
  end

  #Show all exams available for teacher
  def index
    @exam = false
    @exams = Exam.find(:all , :conditions=>{:status=>1}) 
  end
  
  def old_exams
    @exam = false
    @exams = Exam.find(:all , :conditions=>{:status=>0}) 
  end

  #Not applicable
  def edit
  end

  #Arrange the question
  def arrange
    @exam = false
    if params[:id]
      @exam = Exam.find_by_id(params[:id])
      eq = ExamQuestion.find_all_by_exam_id(@exam.id, :order => :position)
      @questions = Array.new
      for e in eq
        @questions.push(Question.find_by_id(e.question_id))
      end
      @questions.delete_at(0)
    else
      redirect_to(:action=>:arrange, :id=>params[:exam_selection])
    end
  end
  
  def save_order
    @exam = Exam.find_by_id(params[:exam_id])
    #@exam.status = 0
    a = (params[:result][:answer]).split(',')
    
    @st_exam = StudentExam.find_by_exam_id(params[:exam_id])
    
    unless @st_exam == nil
    exam = @exam.clone
      
      exam.save
      @exam.status = 0
      @exam.save
      
      @exam = exam
      @exam.add_question(1, :first=>true)
      
    end
      
      
      logger.debug(@exam.inspect)
    
    
    #sets all question in exam to position of -1
    #ExamQuestion.update_all("position = -1 ","exam_id = #{@exam.id}")
    @eq = Array.new(ExamQuestion.find_all_by_exam_id(@exam.id))
    @eq.each {|e| e.position = -1 }
     
    a.insert(0, 1)
    logger.info(a.inspect)
    ExamQuestion.update_all("position = -1","exam_id = #{@exam.id}")
    i = 0; until i == a.length
      eq = ExamQuestion.find_by_exam_id_and_question_id(@exam.id, a[i].to_i)
      unless eq.nil?
        eq.update_attribute(:position, i)
        eq.save
      else
        if Question.find_by_id(a[i].to_i).get_type == :master
          logger.info("multipart")
          @exam.add_multipart(a[i].to_i)
        else
          logger.info("single")
          @exam.add_question(a[i].to_i)
          #updates the position in the exam questions table of new questions that have been added
          ExamQuestion.update_all("position = #{i}","exam_id = #{@exam.id} AND question_id=#{a[i].to_i}")
        end
      end
      i += 1
    end
    
    #deletes any rows that haven't been updated with a new position
    #ie any question removed from the exam will be deleted from the database
    ExamQuestion.delete_all("exam_id = #{@exam.id} AND position = -1")
    
    @questions = Array.new(@exam.questions.find(:all))
    #redirect_to :action => :assign, :id => @exam.id
    if params[:commit] == "Save question list and display question types"
      redirect_to :action => :add_questions, :id => @exam.id, :e_type =>params[:e_type]
    else
      redirect_to :action => :assign, :id => @exam.id
    end
  end
  
  #
  def add_questions
    if params[:commit] == "View Student Reports"
      redirect_to(:action=>:exam_results, :id=>params[:exam_selection])
    elsif params[:commit] == "Old Exams"
    redirect_to(:action=>:old_exams )#, :id=>params[:exam_selection])
    else
      @exam = false
      if params[:id]
        if params[:commit] == "Next: Arrange Questions"
          redirect_to(:action=>:arrange, :id=>params[:id])
        else
          @exam = Exam.find_by_id(params[:id])
          if params[:e_type] == 'All'
          #@exam = Exam.find_by_id(params[:id])
          @questions = Array.new(Question.find(:all,:conditions=>["question_type <> 'New' AND question_type <> 'End' AND master_id is null"]))
          #@questions = Array.new(Question.find(:all,:conditions=>{:question_type => :e_type,:master_id=>nil}))
          #@questions = Array.new(Question.find(:all,:conditions=>{:master_id=>nil}))
          @exam_questions = Array.new(@exam.questions.find(:all, :conditions=>["question_type <> 'New'"]))  

          elsif params[:e_type]
          #@exam = Exam.find_by_id(params[:id])
          #@questions = Array.new(Question.find(:all,:conditions=>{:question_type => @exam.exam_type,:master_id=>nil}))
          @questions = Array.new(Question.find(:all,:conditions=>{:question_type => params[:e_type],:master_id=>nil}))
          #@questions = Array.new(Question.find(:all,:conditions=>{:master_id=>nil}))
          @exam_questions = Array.new(@exam.questions.find(:all, :order => 'position asc'))
          #@questions.delete_at(0)
         
          else
           
          @questions = Array.new(Question.find(:all,:conditions=>{:question_type => @exam.exam_type,:master_id=>nil}))
          #@questions = Array.new(Question.find(:all,:conditions=>{:question_type => :e_type,:master_id=>nil}))
          #@questions = Array.new(Question.find(:all,:conditions=>{:master_id=>nil}))
          @exam_questions = Array.new(@exam.questions.find(:all, :conditions=>["question_type <> 'New'"]))
          #@questions.delete_at(0)
          end

        end
      else
        if params[:exam_selection]
          if params[:commit] == "Assign Students to Selected Test"
            redirect_to(:action=>:assign, :id=>params[:exam_selection]) 
          else
            redirect_to(:action=>:add_questions, :id=>params[:exam_selection])
          end          
        else
          flash[:notice] = "Select an exam to edit"
          redirect_to(:action=>:index)
        end
      end
    end
  end
  
  
  def add
    @exam = Exam.find_by_id(params[:exam_id])
    unless @exam.exam_questions.find_by_question_id_and_exam_id(params[:question_id], @exam.id)
      if Question.find_by_id(params[:question_id]).get_type == :master
        logger.info("multipart")
        @exam.add_multipart(params[:question_id])
      else
        logger.info("single")
        @exam.add_question(params[:question_id])
      end
      flash[:notice] = "Question id " + params[:question_id] + " added to exam."
    else
      flash[:notice] = "You have added this question already. You may change the order at the Arrange page"
    end
    redirect_to(:action => :add_questions, :id => params[:exam_id])
  end
  
  def assign
    @exam = Exam.find_by_id(params[:id])
    @students = Student.find(:all)
    if params[:student]
      for student in @students
        if params[:student][student.id.to_s][:assign] == 1.to_s
          student.assign_exam(@exam.id)
        end
      end
    else
      #something would go in here if we need it
    end
  end
  
  def create_new_exam
    @exam = Exam.new
    if params[:exam]
      @exam = Exam.new(params[:exam])
      @exam.make(:e_name=>params[:exam][:name], :exam_type=>params[:exam_type], :e_status=> 1, :e_skippable => 1) #CHANGE WHEN INTERFACE IS FINISHED, added in default e_status
      if @exam.save
        @exam.add_question(1, :first=>true)
        @exam.add_question(2)
        redirect_to(:action=>:add_questions, :id=>@exam.id)
      end
    end
  end
  
  def report
    @exam = Exam.find_by_id(params[:id])
    @st_exam = StudentExam.find_by_id(params[:subid])
    logger.debug("student_exam: " + @st_exam.inspect)
    @subcategories = @exam.get_subcategories
    @exam_questions = Array.new(@exam.questions.find(:all))
  end
  
  #list students with results for a given exam
  def exam_results
    @exam = Exam.find_by_id(params[:id]) || false
    @st_exams = StudentExam.find_all_by_exam_id(@exam.id)
    if @st_exams.nil? || @st_exams.empty?
      flash[:notice] = "No results for selected exam"
      redirect_to :action=>:index
    end
  end
  
  #show students results
  def student_results
    @exam = false
    @st_exam = StudentExam.find_by_id(params[:id])
    @results = Array.new(Result.find_all_by_student_exam_id(@st_exam.id))
    if params[:r_mark]
      for result in @results
        if params[:r_mark].include?(result.id.to_s)
          result.score = "1"
        else
          result.score = "0"
        end
        result.save
      end
    end
  end
  
  
protected
def authorize
    unless Teacher.find_by_id(session[:teacher_id])
      session[:original_uri] = request.request_uri
      flash[:notice] = "Please login with your user name and password."
      redirect_to :controller => :student, :action => :login
    end
  end
  
  def authorized?
    unless Teacher.find_by_id(session[:teacher_id])
      return false
    else 
      return true
    end
  end

end
