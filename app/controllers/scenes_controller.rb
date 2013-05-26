class ScenesController < ApplicationController
  # GET /scenes
  # GET /scenes.json
  def index
    @project = Project.find(params[:project_id])
    redirect_to project_path(@project) and return
    # @scenes = @project.scenes
    # @backlink = project_path(@project)

    # respond_to do |format|
    #   format.html # index.html.erb
    #   format.json { render json: @scenes }
    # end
  end

  def reorder
    @scene = Scene.find(params[:id])
    @scene.move_to(params[:order_index].to_i)


     render json: @project 

  end

  # # GET /scenes/1
  # # GET /scenes/1.json
  # def show
  #   @scene = Scene.find(params[:id])
  #   @project = @scene.project
  #   @backlink = project_path(@project)

  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.json { render json: @scene }
  #   end
  # end

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
  def edit
    @body_class = "scene-editor"
    @scene = Scene.find(params[:id])
    @project = @scene.project
   # @backlink = project_scenes_path(@project)
    @event_index =  params[:event_index] ? params[:event_index].to_i : @scene.middle_index
    @event_count = @scene.events.count
    @event_index = [@event_index, @event_count].min

  end

  # # POST /scenes
  # # POST /scenes.json
  def create
    @project = Project.find(params[:project_id])
    @scene = @project.scenes.new(params[:scene])
    #load up initial background and music
    @scene.load_initial_events
    respond_to do |format|
      if @scene.save!
        format.html { redirect_to edit_project_scene_path(@project, @scene) }
        format.json { render json: @scene, status: :created, location: @scene }
      else
        flash[:notice] = @scene.errors.full_messages
        format.html { redirect_to :back }
        format.json { render json: @scene.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_event
    @body_class = "scene-editor"
    @scene = Scene.find(params[:id])
    @project = @scene.project
 #   @backlink = project_scenes_path(@project)
    @event = params[:event_id].present? ? Event.find(params[:event_id]) : @scene.events.new
    unless params[:event_id]
      flash[:notice] = "Good job! Add some more!"
    end
    respond_to do |format|
      if @event.update_attributes(params[:event])
        @event_index = @event.reload.order_index
        format.html { redirect_to action: "edit", event_index: @event_index, more_text: params[:more_text], more_text_type: params[:more_text_type]}
        format.json { head :no_content }
      else
        @event_index = @scene.events.count
        format.html { render action: "edit" }
        format.json { render json: @scene.errors, status: :unprocessable_entity }
      end
    end
  end

  # # PUT /scenes/1
  # # PUT /scenes/1.json
  def update
    @scene = Scene.find(params[:id])

    respond_to do |format|
      if @scene.update_attributes(params[:scene])
        format.html { redirect_to edit_project_scene_path(@scene.project, @scene) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @scene.errors, status: :unprocessable_entity }
      end
    end
  end

  # # DELETE /scenes/1
  # # DELETE /scenes/1.json
  def destroy
    @scene = Scene.find(params[:id])
    @scene.destroy

    respond_to do |format|
      format.html { redirect_to action: "index" }
      format.json { head :no_content }
    end
  end
end
