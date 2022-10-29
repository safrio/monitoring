module Geocoder
  class CoordinatesByCityService
    prepend BasicService

    param :city

    def call
      validate
      coordinates
    end

    def coordinates
      @coordinates ||= Geocoder.geocode(city)
    end

    private

    def validate
      return fail_t!(:not_found) unless coordinates.present?
    end

    def fail_t!(key)
      fail!(I18n.t(key, scope: 'services.geocoder.coordinates_by_city_service'))
    end
  end
end
