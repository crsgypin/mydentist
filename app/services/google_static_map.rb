module GoogleStaticMap

	def self.get_map_photo(lat,lng)
    # staticmap_url = "https://maps.googleapis.com/maps/api/staticmap?key=#{key}&maptype=roadmap&markers=color:red%7C#{lat},#{lng}&language=zh-TW&sensor=false&size=500x368&zoom=16"
    url = google_map_image_url(lat, lng)
    Rails.logger.info "get_map_photo, lat: #{lat}, lng: #{lng}, url: #{url}"
    map_file = open(url)
		tmp_file_path = "tmp/#{SecureRandom.random_number(10**5)}_map.jpg"
    IO.copy_stream(map_file, tmp_file_path)
		return tmp_file_path
  end

  def self.google_map_image_url(lat, lng)
    key = Rails.application.config_for('api_key')['google_map']['staticmap_key']
  	"https://maps.googleapis.com/maps/api/staticmap?key=#{key}&maptype=roadmap&markers=color:red%7C#{lat},#{lng}&language=zh-TW&sensor=false&size=500x368&zoom=16"
  end

end

