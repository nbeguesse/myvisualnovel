module ScenesHelper
	def event_to_js event
		if event.is_a?(BackgroundImageEvent)
		 "edit-bg-image"
		elsif event.is_a?(CharacterPoseEvent)
		 "edit-pose"
		else
		 "edit-speak"
		end
	end
	def event_to_command event
		if event.is_a?(BackgroundImageEvent)
		" Change Image"
		elsif event.is_a?(CharacterPoseEvent)
		 " Change Pose"
		else
		 " Edit Text"
		end
	end
end
