class EventsController < ApplicationController
  before_filter :get_event
  def moveup
    prev_event = Event.where(:scene_id=>@scene.id, :order_index=>@event.order_index-1).first
    @event.update_attribute(:order_index, @event.order_index-1)
    prev_event.update_attribute(:order_index, prev_event.order_index+1)
    @event.reorder_indexes

    respond_to do |format|
      format.html { redirect_to edit_project_scene_path(@project, @scene, :event_index=>@event.order_index) }
      format.json { head :no_content }
    end
  end

  def movedown
    next_event = Event.where(:scene_id=>@scene.id, :order_index=>@event.order_index+1).first
    @event.update_attribute(:order_index, @event.order_index+1)
    next_event.update_attribute(:order_index, next_event.order_index-1)
    @event.reorder_indexes


    respond_to do |format|
      format.html { redirect_to edit_project_scene_path(@project, @scene, :event_index=>@event.order_index) }
      format.json { head :no_content }
    end
  end

  # # DELETE /events/1
  # # DELETE /events/1.json
  def delete
    @event.destroy
    event_index = [@event.order_index, @scene.events.count].min
    respond_to do |format|
      format.html { redirect_to edit_project_scene_path(@project, @scene, :event_index=>event_index) }
      format.json { head :no_content }
    end
  end

  def get_event
    @event = Event.find_by_id(params[:id])
    if @event.nil?
      not_found
      return false
    elsif !@event.scene.project.owner?(session_obj)
      not_authorized
      return false
    end
    @scene = @event.scene
    @project = @scene.project
    true
  end
end
