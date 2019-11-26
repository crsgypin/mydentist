module Common::GeocoderHelper

	def get_lat_lang_by_address(address)
		result = Geocoder.search(address)
		data = result[0].data
		loc = data["geometry"]["location"]
		r = {lat: loc["lat"], lng: loc["lng"]}
		r
	end

	def google_map_api_key
		key = Rails.application.config_for('api_key')['google_map']['key']		
	end

	def google_map_script(callback_name, libraries=nil)
		libraries ||= "geometry"
		k = "<script type='text/javascript'>"
		k += "var url1 = '//maps.google.com/maps/api/js?v=3.34&key=#{google_map_api_key}&sensor=false&libraries=#{libraries}';"
	 	k += "var head = document.getElementsByTagName('head')[0];"
	  k += "var script1 = document.createElement('script');"
	  k += "script1.type = 'text/javascript';"
	  k += "script1.src = url1;"
	  k += "script1.addEventListener('load', function(){"
	  k += "	#{callback_name}();"
	  k += "});"
	  k += "document.body.appendChild(script1);"
	  k += "</script>"
	  k.html_safe
		# script = "<script src='https://maps.google.com/maps/api/js?v=3.34&key=#{google_map_api_key}&sensor=false&libraries=geometry&callback=#{init_event_name}'></script>".html_safe;
	end

#example of result
# [
#  [0] #<Geocoder::Result::Google:0x007fc96decc5f0 
#	 "address_components"=>[
#	  {"long_name"=>"Taipei", 
#    "short_name"=>"Taipei", 
#    "types"=>["colloquial_area", "locality", "political"]}, 
#   {"long_name"=>"Taiwan", 
#    "short_name"=>"TW", 
#    "types"=>["country", "political"]}
#   ], 
#   "formatted_address"=>"Taipei, Taiwan", 
#   "geometry"=>{
#  		"bounds"=>{
#  			"northeast"=>{
#  				"lat"=>25.2443731, 
#  				"lng"=>121.7300824
#  				}, 
#  			"southwest"=>{
#  				"lat"=>24.7900797, 
#  				"lng"=>121.2826735
#  				}
#  		}, 
#  	"location"=>{
#  		"lat"=>25.0329694, 
#  		"lng"=>121.5654177
#		}, 
#  	"location_type"=>"APPROXIMATE", 
#  	"viewport"=>{
#  		"northeast"=>{
#  			"lat"=>25.2443731, 
#  			"lng"=>121.7300824
#  			}, 
#  		"southwest"=>{
#  			"lat"=>24.7900797, 
#  			"lng"=>121.2826735
#  			}
#  		}
#  	}, 
#  	"place_id"=>"ChIJmQrivHKsQjQR4MIK3c41aj8", 
#  	"types"=>["colloquial_area", "locality", "political"]},
#  	 @cache_hit=nil>
# ]


end


