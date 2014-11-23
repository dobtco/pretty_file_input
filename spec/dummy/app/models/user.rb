class User < ActiveRecord::Base
  mount_uploader :avatar, CarrierWave::Uploader::Base
end
