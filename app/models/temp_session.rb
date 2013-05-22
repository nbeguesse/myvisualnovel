#this is just a container for holding cars before the user has logged in.
class TempSession
  def self.find(num, options)
    nil
  end

  def initialize(options)
  	@options = options
  end

  def id
  	@options[:id]
  end

  def projects
    Project.where(:owner_id=>self.id.to_s)
  end

  def cart
    has_cart? || Cart.create(:owner_id=>self.id, :owner_type=>self.class.to_s)
  end

  def has_cart?
    Cart.find_by_owner_id(self.id)
  end

  def type
    "TempSession"
  end


  def copy_to(user)
    Rails.logger.info "IN TEMP SESSION COPY TO"
    projects.each do |project|
      duplicate = Project.where(:owner_id=>user.id.to_s, :basename=>project.basename).first
      unless duplicate
        project.owner_id = user.id.to_s
        project.owner_type = "User"
      end
      Rails.logger.info "SAVING PROJECT"
      project.save!
    end
  end

end