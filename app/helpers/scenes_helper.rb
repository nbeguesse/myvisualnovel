module ScenesHelper
	def event_to_js event
		if event.is_a?(BackgroundImageEvent)
		 "edit-bg-image"
		elsif event.is_a?(CharacterPoseEvent)
		 "edit-pose"
		elsif event.is_a?(BackgroundMusicEvent)
		 "edit-music"
		else
		 "edit-speak"
	
		end
	end
	def event_to_command event
		if event.is_a?(BackgroundImageEvent)
		" Change Image"
		elsif event.is_a?(CharacterPoseEvent)
		 " Change Pose"
		elsif event.is_a?(BackgroundMusicEvent)
		 " Change Music"
		else
		 " Edit Text"
		end
	end

	def glass_box_class event
		return "" if event && event.is_a?(CharacterSpeaksEvent) || event.is_a?(CharacterSpeaksEvent)
		return "hide"
	end
	def narration_box_class event
		return "" if event && event.is_a?(NarrationEvent) 
		return "hide"
	end
end
