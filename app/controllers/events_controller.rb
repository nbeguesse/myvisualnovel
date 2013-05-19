class EventsController < ApplicationController
  def moveup
    event = Event.find(params[:id])
    scene = event.scene
    prev_event = Event.where(:scene_id=>scene.id, :order_index=>event.order_index-1).first
    event.update_attribute(:order_index, event.order_index-1)
    prev_event.update_attribute(:order_index, prev_event.order_index+1)
    event.reorder_indexes
    respond_to do |format|
      format.html { redirect_to edit_project_scene_path(scene.project, scene, :event_index=>event.order_index) }
      format.json { head :no_content }
    end
  end

  def movedown
    event = Event.find(params[:id])
    scene = event.scene
    next_event = Event.where(:scene_id=>scene.id, :order_index=>event.order_index+1).first
    event.update_attribute(:order_index, event.order_index+1)
    next_event.update_attribute(:order_index, next_event.order_index-1)
    event.reorder_indexes
    respond_to do |format|
      format.html { redirect_to edit_project_scene_path(scene.project, scene, :event_index=>event.order_index) }
      format.json { head :no_content }
    end
  end

  # # DELETE /events/1
  # # DELETE /events/1.json
  def delete
    @event = Event.find(params[:id])
    @scene = @event.scene
    @project = @scene.project
    @event.destroy

    respond_to do |format|
      format.html { redirect_to edit_project_scene_path(@project, @scene, :event_index=>@event.order_index) }
      format.json { head :no_content }
    end
  end
end
