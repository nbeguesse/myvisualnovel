class CharactersController < ApplicationController

  def index
    @project = Project.find(params[:project_id])
    if !@project.owner?(session_obj)
      not_authorized and return
    end
    @characters = @project.characters
    @backlink = project_path(@project)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @characters }
    end
  end


  # def show
  #   @character = Character.find(params[:id])

  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.json { render json: @character }
  #   end
  # end


  # def new
  #   @character = Character.new

  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render json: @character }
  #   end
  # end


  # def edit
  #   @character = Character.find(params[:id])
  # end


  # def create
  #   @character = Character.new(params[:character])

  #   respond_to do |format|
  #     if @character.save
  #       format.html { redirect_to @character, notice: 'Character was successfully created.' }
  #       format.json { render json: @character, status: :created, location: @character }
  #     else
  #       format.html { render action: "new" }
  #       format.json { render json: @character.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def toggle
    @project = Project.find(params[:project_id])
    if !@project.owner?(session_obj)
      not_authorized and return
    end
    notice = nil
    named_character = params[:character_type].constantize
    if existing = named_character.first(:conditions=>["project_id=?",@project.id])
      @project.characters.delete(existing)
      existing.destroy
      notice = "#{existing.name} was removed."
    else
      @project.characters << named_character.new
      notice = "You added them to the project. Now you can change their name!"
    end
    respond_to do |format|
      if true
        format.html { redirect_to project_characters_path(@project), notice: notice }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @character.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    @character = Character.find(params[:id])
    @project = @character.project
    if !@project.owner?(session_obj)
      not_authorized and return
    end
    respond_to do |format|
      if @character.update_attributes(params[:character])
        format.html { redirect_to project_characters_path(@project), notice: 'Character changed!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @character.errors, status: :unprocessable_entity }
      end
    end
  end


  # def destroy
  #   @character = Character.find(params[:id])
  #   @character.destroy

  #   respond_to do |format|
  #     format.html { redirect_to characters_url }
  #     format.json { head :no_content }
  #   end
  # end
end
