class AdminController < ApplicationController
  
  #Use the layout in Views/layouts/admin.html.erb
  layout 'admin'
  
  #User has to login first before access
  before_filter :authorize, :except => [:login, :logout, :about]
  
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
  
  #Log out by reset_session
  def logout
    @exam = false
    reset_session
    
    respond_to do |format|
      format.html
    end
  end
  
  #Get all details from database order by login_id, accessable only by admin
  #Show the details to index.html.erb
  def index
      @students = Student.find(:all, :order => :login_id)
      @teachers = Teacher.find(:all, :order => :login_id)
      @admins = Admin.find(:all, :order => :login_id)       
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def about
    
    
  end
  
  #Get the student id that will be assigned to, find all exams that available
  #Create a new StudentExam object, go to assignment.html.erb
  def assignment
    @student = Student.find(params[:id])
    @exams = Exam.find(:all , :conditions=>{:status=>1})
    @st_exam = StudentExam.new    
    
    respond_to do |format|
      format.html 
     
    end
  end
  
  #Assign the student with the selected exam(s) from user
  #If exam is assigned, show a success message, otherwise error message
  def assign
    @student = Student.find(params[:id])
    if params[:exam]
      a = params[:exam]
      b = Array.new(a.values_at(:id)[0])
      logger.debug(a.to_s)
      logger.debug(b.inspect)
      @st_exams = Array.new
      i = 0; until i == b.length
        st_exam = @st_exams.push(StudentExam.new)
        logger.debug(st_exam.inspect)
        st_exam.last.exam_id = b[i]
        st_exam.last.student_id = @student.id
        st_exam.last.radio_button_exam = 0
        st_exam.last.status = 1
        st_exam.last.save
        i+=1
      end

      flash[:notice] = "Exam was successfully assigned"
      redirect_to :action => :index
    else
      flash[:notice] = "No exam selected. Please select an exam or more."
      redirect_to :action => :assignment, :id => params[:id]
    end
  end


  #Show student's details, go to show_student.html.erb
  def show_student
    @student = Student.find(params[:id])
    
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @student }
    end
  end
  
  #Show teacher's details, go to show_teacher.html.erb
  def show_teacher
    @teacher = Teacher.find(params[:id])
    
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @teacher }
    end
  end
  
  #Show admin's details, go to show_admin.html.erb
  def show_admin
    @admin = Admin.find(params[:id])
    
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @admin }
    end
  end
  
  #Create a new student object, go to create_new_student.html.erb
  def create_new_student
    @student = Student.new

    respond_to do |format|
      format.html 
    end
  end
  
  #Create a new teacher object, go to create_new_teacher.html.rb
  def create_new_teacher
    @teacher = Teacher.new
    
    respond_to do |format|
      format.html 
    end
  end
  
  #Create new admin object, go to create_new_admin.html.erb
  def create_new_admin
    @admin = Admin.new
    
    respond_to do |format|
      format.html 
    end
  end
  
   #Creating student from create_new_student.html.erb
   #Redirect to index.html
  def create_student
    @student = Student.new(params[:student])
    logger.debug("student: " + @student.to_s + params[:student].to_s)
    @student.enabled = true
    logger.debug(@student.display_details)

    respond_to do |format|
      if @student.save
        flash[:notice] = "Student #{@student.name} was successfully created."
        format.html { redirect_to(:action=>:index) }
        
      else
        format.html { render :action => "create_new_student" }
      end
    end
  end

   #Creating teacher from create_new_teacher.html.erb
   #Redirect to index.html
  def create_teacher
    @teacher = Teacher.new(params[:teacher])
    #logger.debug("teacher: " + @user.to_s + params[:user].to_s)
    @teacher.enabled = true
    #logger.debug(@user.display_details)

    respond_to do |format|
      if @teacher.save
        flash[:notice] = "Teacher #{@teacher.name} was successfully created."
        format.html { redirect_to(:action => :index) }
        
      else
        format.html { render :action => "create_new_teacher" }
      end
    end
  end
  
  #Creating student from create_new_admin.html.erb
  #Redirect to index.html
  def create_admin
    @admin = Admin.new(params[:admin])
    @admin.enabled = true
    
    respond_to do |format|
      if @admin.save
        flash[:notice] = "Admin #{@admin.name} was successfully created."
        format.html { redirect_to(:action => :index) }
        
      else
        format.html { render :action => "create_new_admin" }
      end
    end
  end

  #Edit student, find the student by ID
  def edit_student
    @student = Student.find(params[:id])
    
    #respond_to do |format|
     # format.html # show.html.erb
      #format.xml  { render :xml => @student }
    #end
  end
  
  #Edit teacher, find the teacher by ID
  def edit_teacher
    @teacher = Teacher.find(params[:id])
    
   # respond_to do |format|
    #  format.html # show.html.erb
    #  format.xml  { render :xml => @teacher }
   # end
  end
  
  #Edit admin, find the admin by ID
  def edit_admin
    @admin = Admin.find(params[:id])
    
  end
   
  #Update student details, find the student by ID then update the student details
  #from edit_student.html.erb
  def update_student
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
        flash[:notice] = "Student #{@student.name} was successfully updated."
        format.html { redirect_to(:action => :index) }
      else
        format.html { render :action => "edit_student" }
      end
    end
  end
  
  #Update teacher details, find the teacher by ID then update the teacher details
  #from edit_teacher.html.erb
  def update_teacher
    @teacher = Teacher.find(params[:id])

    respond_to do |format|
      if @teacher.update_attributes(params[:teacher])
        flash[:notice] = "Teacher #{@teacher.name} was successfully updated."
        format.html { redirect_to(:action => :index) }
      else
        format.html { render :action => "edit_teacher" }
      end
    end
  end
  
  #Update admin details, find the admin by ID then update the admin details
  #from edit_admin.html.erb
  def update_admin
    @admin = Admin.find(params[:id])

    respond_to do |format|
      if @admin.update_attributes(params[:admin])
        flash[:notice] = "Admin #{@admin.name} was successfully updated."
        format.html { redirect_to(:action => :index) }
      else
        format.html { render :action => "edit_admin" }
      end
    end
  end

  #Delete student, find the student by ID then delete the student
  #from index.html.erb
  def destroy_student
    @student = Student.find(params[:id])
    @st_exams = StudentExam.find_all_by_student_id(@student.id)
    @student.destroy
    StudentExam.destroy(@st_exams)
    
    flash[:notice] = "Student #{@student.name} was successfully deleted."
    respond_to do |format|
      format.html { redirect_to(:action => :index) }
    end
  end

  #Delete teacher, find the teacher by ID then delete the teacher
  #from index.html.erb
  def destroy_teacher
    @teacher = Teacher.find(params[:id])
    @teacher.destroy
    flash[:notice] = "Teacher #{@teacher.name} was successfully deleted."
    respond_to do |format|
      format.html { redirect_to(:action => :index) }
    end
  end
  
  #Delete admin, find the admin by ID then delete the admin
  #from index.html.erb
  def destroy_admin
    @admin = Admin.find(params[:id])
    @admin.destroy
    flash[:notice] = "Admin #{@admin.name} was successfully deleted."
    respond_to do |format|
      format.html { redirect_to(:action => :index) }
    end
  end
  
  #Show student's results, find the student by ID then find the exam that assigned to that student
  def student_results
    @student = Student.find_by_id(params[:id])
    @st_exams = Array.new(@student.student_exams)
  end
  
  #Create a new exam object, and find all question that available to that exam
  def new_exam
    @exam = Exam.new
    @questions = Question.find(:all)
  end

  def add_choices
    @question = Question.find_by_id(params[:id])
    if params[:choice_input]
      for choice in params[:choice_input]
        @question.add_choice(choice.to_s)
      end
      redirect_to :action=>:index
      flash[:notice] = "Choices added"
    else
      @choices = params[:choices].to_i
      @choices = 2 if @question.get_type == :true_false
    end
  end
  
  #Not Applicable
  def save_choice
    
  end
  
  #Not Applicable
  def save_new_question
    @question = Question.new
    @question.make(params[:q_category], params[:q_subcategory], params[:q_type], params[:q_text])
    @question.question_type = params[:question_type]
    @question.save
    logger.debug("question: " + @question.inspect + params[:question].to_s)
    #@question.make(@question.q_category, @question.q_subcategory, @question.q_type, @question.q_text)

    logger.debug("Make question success")
    
      if @question
        if @question.get_type == :multiple || @question.get_type == :true_false
          logger.debug("Redirecting to add_choices")
          redirect_to(:action=>:add_choices, :id=>@question.id, :choices=>params[:q_choices])
        else
          flash[:notice] = "Question was successfully created."
          redirect_to(:action =>:index)
        end
      else
        render :action => "new_question"
      end
  end
  
  #Not Applicable
  def add_question_xml
    @question = Question.new
  end
  
  #Not Applicable
  def save_new_question_xml
    @question = Question.new
    @question.q_data = params[:q_data]
    @question.question_type = params[:question_type]
    @question.master_id = params[:master_id]
    @question.save
    redirect_to(:action=>:index)
  end
  

  def make_exam
    @exam = Exam.new(params[:exam])
    @exam.save

    @exam.status = params[:status].collect{|char| char.to_i}
    params[:question][:id].each {|d| @exam.add_question(d)}


    respond_to do |format|
      format.html { redirect_to(:action=>:exam_index)}
    end
  end

  #Show all exam available
  def exam_index
    @exams = Exam.find(:all)

    respond_to do |format|
        format.html
    end
  end
  
  #Edit exam, find exam details
  #Currently will do the same as showing the exam details
  def edit_exam
    @exam = Exam.find(params[:id])
    @questions = @exam.questions.find(:all)
    @all_questions = Question.find(:all)
  end
  
  #Update the exam, find the exam ID , then update the exam
  def update_exam
    @exam = Exam.find(params[:id])

    respond_to do |format|
      if @exam.update_attributes(params[:exam])
        flash[:notice] = "Exam #{@exam.name} was successfully updated."
        format.html { redirect_to(:action=>:index) }
      else
        format.html { render :action => "edit_exam" }
      end
    end
  end

  #Destroy the exam, find the exam id then delete the exam
  def destroy_exam
    @exam = Exam.find(params[:id])
    @exam.destroy

    respond_to do |format|
      format.html { redirect_to(:action=>:exam_index) }
    end
  end
  
  
   def xml_index
    @questions = Question.find(:all, :conditions=>{:depreciated=>0})
    @questions.delete_at(0)
  end
  
  def show_question_xml
    @question = Question.find_by_id(params[:id])
  end
  
  def delete_xml
    Question.find_by_id(params[:id]).destroy
    redirect_to :action=>:xml_index
  end
  
  protected
  
def authorize
    unless Admin.find_by_id(session[:admin_id])
      session[:original_uri] = request.request_uri
      flash[:notice] = "Please login with your user name and password."
      redirect_to :controller => :student, :action => :login
    end
  end
  
  def authorized?
    unless Admin.find_by_id(session[:admin_id])
      return false
    else 
      return true
    end
  end


end
