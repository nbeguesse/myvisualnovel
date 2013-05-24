class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  def index
    @backlink = root_url
    @projects = session_obj.projects
    if @projects.empty?
      redirect_to new_project_path and return
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end
  def play
    @project = Project.find_by_id_and_basename(params[:id],params[:basename])
    if @project && @project.public?
      if params[:scene_id]
        @scenes = [Scene.find(params[:scene_id])]
      else
        @scenes = @project.scenes.ordered
      end
      if @scenes.empty?
        flash[:notice] = "Please add some scenes first."
        redirect_to project_path
        return
      end
      render :layout=>'viewer'
    else
      flash[:error] = "Sorry, we couldn't find that visual novel."
      redirect_to root_url
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])
    @backlink = projects_path
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new
    @backlink = projects_path

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
    @backlink = project_url(@project)
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(params[:project])
    first_project = session_obj.projects.empty?
    @project.owner_id = session_obj.id
    @project.owner_type = session_obj.type
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
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # # DELETE /projects/1
  # # DELETE /projects/1.json
  # def destroy
  #   @project = Project.find(params[:id])
  #   @project.destroy

  #   respond_to do |format|
  #     format.html { redirect_to projects_url }
  #     format.json { head :no_content }
  #   end
  # end
end
