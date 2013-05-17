class ScenesController < ApplicationController
  # GET /scenes
  # GET /scenes.json
  def index
    @project = Project.find(params[:project_id])
    @scenes = @project.scenes
    @backlink = project_path(@project)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @scenes }
    end
  end

  # # GET /scenes/1
  # # GET /scenes/1.json
  def show
    @scene = Scene.find(params[:id])
    @project = @scene.project
    @backlink = project_path(@project)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @scene }
    end
  end

  # # GET /scenes/new
  # # GET /scenes/new.json
  # def new
  #   @scene = Scene.new

  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render json: @scene }
  #   end
  # end

  # # GET /scenes/1/edit
  # def edit
  #   @scene = Scene.find(params[:id])
  # end

  # # POST /scenes
  # # POST /scenes.json
  def create
    @project = Project.find(params[:project_id])
    @scene = @project.scenes.new
    #load up initial background and music
    if location = params[:location].try(:constantize)
      @scene.events = location.events
    end
    respond_to do |format|
      if @scene.save!
        format.html { redirect_to project_scene_path(@project, @scene), notice: 'Scene was successfully created.' }
        format.json { render json: @scene, status: :created, location: @scene }
      else
        flash[:notice] = @scene.errors.full_messages
        format.html { redirect_to :back }
        format.json { render json: @scene.errors, status: :unprocessable_entity }
      end
    end
  end

  # # PUT /scenes/1
  # # PUT /scenes/1.json
  # def update
  #   @scene = Scene.find(params[:id])

  #   respond_to do |format|
  #     if @scene.update_attributes(params[:scene])
  #       format.html { redirect_to @scene, notice: 'Scene was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @scene.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /scenes/1
  # # DELETE /scenes/1.json
  # def destroy
  #   @scene = Scene.find(params[:id])
  #   @scene.destroy

  #   respond_to do |format|
  #     format.html { redirect_to scenes_url }
  #     format.json { head :no_content }
  #   end
  # end
end
