module ScenesHelper
    def to_sentence event
      if event.is_a?(NarrationEvent)
      	'<small class="detail muted">'.html_safe+event.detail+'</small>'.html_safe
      elsif event.glassbox?
      	event.to_sentence+'<br/><small class="detail">'.html_safe+event.detail+'</small>'.html_safe
      else
      	'<span class="muted">'.html_safe+event.to_sentence+'</span><br/><small class="detail muted">'.html_safe+event.detail+'</small>'.html_safe
      end
    	# <%unless event.is_a?(NarrationEvent)%>
	  		#   <span class='muted'><%=event.to_sentence%></span><br/>
	  		# <%end%>
	  		# <small class="detail"><%=event.detail%></small>
    end

	def event_to_js event
		if event.is_a?(CharacterPoseEvent) && @scene.love_scene?
		 "edit-pose"
		elsif event.is_a?(CharacterPoseEvent)
		 "edit-clothes"
		elsif event.is_a?(BackgroundImageEvent) ||  event.is_a?(LovePoseEvent)
		 "edit-bg-image"
		elsif event.is_a?(BackgroundMusicEvent)
		 "edit-music"
		else
		 "edit-speak"
	
		end
	end
	def event_to_command event
		if event.is_a?(CharacterPoseEvent) && @scene.love_scene?
		 " Change Pose"
		elsif event.is_a?(CharacterPoseEvent)
		 " Change Clothes"
		elsif event.is_a?(BackgroundImageEvent) || event.is_a?(LovePoseEvent)
		" Change Background"
		elsif event.is_a?(BackgroundMusicEvent)
		 " Change Music"
		else
		 " Edit Text"
		end
	end

	# def glass_box_class event
	# 	return "" if event && event.is_a?(CharacterSpeaksEvent) || event.is_a?(CharacterSpeaksEvent)
	# 	return "hide"
	# end
	# def narration_box_class event
	# 	return "" if event && event.is_a?(NarrationEvent) 
	# 	return "hide"
	# end
	def subcommand event
		return "" if @scene.love_scene?
		if event.is_a?(CharacterPoseEvent)
		  raw('<a data-character-id="'+event.character_id.to_s+'" href="#" class="btn btn-small edit-face"><i class="icon-pencil"></i> Change Face</a>')
		else
			""
		end
	end
end
