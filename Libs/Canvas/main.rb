class Main < Basic
	attr_accessor :mode, :activated, :showable, :screen, :slot
	def initialize a, hash
		@a = a
		hash.keys.each do |key|
			case key
				when :activated
					@activated = hash[key]
				when :showable
					@showable = hash[key]
				when :screen
					@screen = hash[key]
					case @screen
						when "apps"
							screen = app_screen
						when "help"
							screen = help_screen
						when "home"
							screen = home_screen
						when "reader"
							screen = reader_screen
						when "selector"
							screen = selector_screen
						when "settings"
							screen = settings_screen
						when "skills"
							screen = skill_screen
						else
							screen = home_screen
					end
					@does = screen[0]
					@slot = screen[1]
				when :mode
					case (hash[key]=hash[key].split("_", 2))[0]
						when "vertical"
							@mode = "vertical"
							@width = (hash[:size]*0.01*$width).to_i
							@height = ($level_1_h*0.01*$height).to_i
					end
			end
		end
	end
end