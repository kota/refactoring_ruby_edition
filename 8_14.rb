require 'forwardable'

class RigidMountainBike
  def initialize(params)
    @base_price = params[:base_price]
    @commission = params[:commission]
    @tire_width = params[:tire_width]
  end

  def price
    (1 + @commission) * @base_price
  end

  def off_road_ability
    @tire_width * MountainBike::TIRE_WIDTH_FACTOR
  end

  def upgradable_parameters
    {
      :tire_width => @tire_width,
      :base_price => @base_price,
      :commission => @commission
    }
  end
end

class FrontSuspensionMountainBike
  def initialize(params)
    @base_price = params[:base_price]
    @commission = params[:commission]
    @tire_width = params[:tire_width]
    @front_fork_travel = params[:front_fork_travel]
    @front_suspension_price = params[:front_suspension_price]
  end

  def price
    (1 + @commission) * @base_price + @front_suspension_price
  end

  def off_road_ability
    @tire_width * MountainBike::TIRE_WIDTH_FACTOR + @front_fork_travel * MountainBike::FRONT_SUSPENSION_FACTOR
  end

  def upgradable_parameters
    {
      :tire_width => @tire_width,
      :front_fork_travel => @front_fork_travel,
      :front_suspension_price => @front_suspension_price,
      :base_price => @base_price,
      :commission => @commission
    }
  end
end

class FullSuspensionMountainBike
  def initialize(params)
    @base_price = params[:base_price]
    @commission = params[:commission]
    @tire_width = params[:tire_width]
    @front_fork_travel = params[:front_fork_travel]
    @front_suspension_price = params[:front_suspension_price]
    @rear_fork_travel = params[:rear_fork_travel]
    @rear_suspension_price = params[:rear_suspension_price]
  end

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
  extend Forwardable
  def_delegators :@bike_type, :off_road_ability, :price

  TIRE_WIDTH_FACTOR = 1
  FRONT_SUSPENSION_FACTOR = 1
  REAR_SUSPENSION_FACTOR = 1

  def initialize(bike_type)
    @bike_type = bike_type
  end

  def add_front_suspension(params)
    @bike_type = FrontSuspensionMountainBike.new(
      @bike_type.upgradable_parameters.merge(params)
    )
  end

  def add_rear_suspension(params)
    unless @bike_type.is_a?(FrontSuspensionMountainBike)
      raise "You can't add rear suspension unless you have front suspension"
    end
    @bike_type = FullSuspensionMountainBike.new(
      @bike_type.upgradable_parameters.merge(params)
    )
  end

end

bike = MountainBike.new(FrontSuspensionMountainBike.new(
  :tire_width => 2.5,
  :front_fork_travel => 10,
  :front_suspension_price => 800,
  :base_price => 1000,
  :commission => 0.05
))

puts bike.price

bike.add_rear_suspension(
  :rear_fork_travel => 10,
  :rear_suspension_price => 900
)

puts bike.price
