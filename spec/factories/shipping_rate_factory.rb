# Included for backward compatability with Solidus version < v1.2

version = Spree.try(:solidus_gem_version)

# Only include the shipping_rate factory if it hasn't yet
# been created in Solidus.
unless version && version >= Gem::Version.new("1.2")
  FactoryGirl.define do
    factory :shipping_rate, class: Spree::ShippingRate do
      shipping_method
      shipment
    end
  end
end
