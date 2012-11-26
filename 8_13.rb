module FrontSuspensionMountainBike
  def price
    (1 + @commission) * @base_price + @front_suspension_price   
  end

  def off_road_ability
    @tire_width * MountainBike::TIRE_WIDTH_FACTOR + @front_fork_travel * MountainBike::FRONT_SUSPENSION_FACTOR
  end
end

module FullSuspensionMountainBike
  def price
    (1 + @commission) * @base_price + @front_suspension_price + @rear_suspension_price
  end

  def off_road_ability
    @tire_width * MountainBike::TIRE_WIDTH_FACTOR + 
    @front_fork_travel * MountainBike::FRONT_SUSPENSION_FACTOR + 
    @rear_fork_travel * MountainBike::REAR_SUSPENSION_FACTOR
  end
end


class MountainBike

  TIRE_WIDTH_FACTOR = 1
  FRONT_SUSPENSION_FACTOR = 1
  REAR_SUSPENSION_FACTOR = 1

  attr_writer :type_code

  def initialize(params)
    @commission = params[:commission]
    @base_price = params[:base_price]
    @front_suspension_price = params[:front_suspension_price]
  end

  def type_code=(mod)
    extend(mod)
  end

  def off_road_ability
    @tire_width * TIRE_WIDTH_FACTOR
  end

  def price
    (1 + @commission) * @base_price
  end

end

bike = MountainBike.new(:commission => 0.05, :base_price => 1000, :front_suspension_price => 800)
puts bike.price
bike.type_code = FrontSuspensionMountainBike
puts bike.price
