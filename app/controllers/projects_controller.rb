class ProjectsController < ApplicationController
  before_filter :get_project, :only=>[:show, :edit, :update, :destroy]
  # GET /projects
  # GET /projects.json
  def index
    @backlink = root_path
    @projects = session_obj.projects
    @include_cool_font = @projects.map{|p|p.title.titleize}.join
    if @projects.empty?
      redirect_to new_project_path and return
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end
  def play
    @html_class = "player"
    @project = Project.find_by_id_and_basename(params[:id],params[:basename])
    @after_events = []
    @before_events = []
    if @project && (@project.public? || @project.owner?(session_obj))
      if params[:scene_id]
        @only_scene = true
        @scenes = [Scene.find(params[:scene_id])]
      else
        @only_scene = false
        @project.increment!(:views)
        @scenes = @project.scenes.ordered
      end
      if @project.temp?
        flash.now[:notice] = "Make sure to login to save your work."
      end
      if @scenes.empty?
        flash[:notice] = "Please add some scenes first."
        redirect_to project_path
        return
      end
      # unless @only_scene
      #   @before_events << TitleCardEvent.title
      #   @after_events << TitleCardEvent.default_credits 
      # end

    else
      not_found
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @backlink = projects_path
    #@page_title = @project.title
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new
    @backlink = root_path

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @backlink = project_path(@project)
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(params[:project])
    first_project = session_obj.projects.empty?
    @project.owner_id = session_obj.id
    @project.owner_type = session_obj.type
    set_adult_cookie
    respond_to do |format|
      if @project.save
        if first_project
          flash[:notice] = "Congrats on making your first visual novel! I gave you an example scene to get you up and running."
          #TODO: Add Example Scene
        end
        format.html { redirect_to @project }
        format.json { render json: @project, status: :created, location: @project }
      else
        @backlink = projects_path
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to project_path(@project) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end
  def get_project
    @project = Project.find_by_id(params[:id])
    if @project.nil?
      not_found
      return false
    elsif !@project.owner?(session_obj)
      not_authorized
      return false
    end
  end
  # # DELETE /projects/1
  # # DELETE /projects/1.json
  def destroy

    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end
end
