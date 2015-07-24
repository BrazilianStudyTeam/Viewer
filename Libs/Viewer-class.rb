class Viewer
	def initialize
		Shoes.app(height: $height, width: $width, title: $title, fullscreen: $fullscreen, resizable: false) do
			@canvas1_settings = []
			@canvas1_object = []
			@canvas1_settings << $main_1 if $main_1[:activated]==true
			@canvas1_settings << $main_2 if $main_2[:activated]==true
			@canvas1_settings << $main_3 if $main_3[:activated]==true
			@canvas1_settings << $main_4 if $main_4[:activated]==true
			@canvas1_settings << $main_5 if $main_5[:activated]==true

			@canvas1_settings.each do |x| @canvas1_object << Main.new(self, x); end
			@canvas2 = MenuBar.new(self)
			@canvas3 = InformationBar.new(self)

			$level_1 = flow height: ($level_1_h*height*0.01).to_i, width: width do end
			$level_2 = flow height: ($level_2_h*height*0.01).to_i, width: width do end
			$level_3 = flow height: ($level_3_h*height*0.01).to_i, width: width do end

			$level_1.append do @canvas1_object.each do |x| x.does.call if x.mode=="vertical"; end; end
			$level_2.append do @canvas2.does.call; end
  			$level_3.append do @canvas3.does.call; end

  		end
	end
end