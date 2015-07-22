class Viewer
	def initialize
		Shoes.app(height: $height, width: $width, title: $title, fullscreen: $fullscreen, resizable: $resizable) do
			background white
			
			@canvas1_1 = Main.new(self)
			@canvas1_2 = Main.new(self)
			@canvas1_3 = Main.new(self)
			@canvas1_4 = Main.new(self)
			@canvas1_5 = Main.new(self)
			@canvas2   = MenuBar.new(self)
			@canvas3   = InformationBar.new(self)

			@level1 = flow() do
				@canvas1_1.does
				@canvas1_2.does
				@canvas1_3.does
				@canvas1_4.does
				@canvas1_5.does
			end
			@level2 = flow() do
				@canvas2.does
			end
			@level3 = flow() do
				@canvas3.does
			end
		end
	end

end