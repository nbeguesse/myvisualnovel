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

  def cars
    Car.where(:owner_id=>self.id.to_s, :removed=>false)
  end

  def cart
    has_cart? || Cart.create(:owner_id=>self.id, :owner_type=>self.class.to_s)
  end

  def has_cart?
    Cart.find_by_owner_id(self.id)
  end

  def window_label
    WindowLabel.for_obj(self)
  end
  def qr_label
    QrLabel.for_obj(self)
  end

  def copy_to(user)
    cars.each do |car|
      duplicate = Car.where(:owner_id=>user.id.to_s).first
      car.owner = user unless duplicate
      car.save!
    end
    if has_cart?
      cart.line_items.each do |li|
        li.cart_id = user.cart.id
        li.save!
      end
      cart.destroy
    end
  end

end