class Narrator < Character
  FULL_BODY = "edgeworth.gif"
  FACE_ICON = "edgeworth.gif"
  def default_description
  	"The mysterious new transfer student. Some people are afraid of him, but he's really just shy around girls."
  end

  def is_narrator?
  	true
  end
end
