class Narrator < Male
  FULL_BODY = "edgeworth.gif"
  FACE_ICON = "edgeworth.gif"
  
  def default_name
  	"Protagonist"
  end

  def is_narrator?
  	true
  end
end
