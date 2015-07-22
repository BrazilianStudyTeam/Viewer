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
			@canvas3   = Informationbar.new(self)

			@level1 = flow() do
				@canvas1_1.do
				@canvas1_2.do
				@canvas1_3.do
				@canvas1_4.do
				@canvas1_5.do
			end
			@level2 = flow() do
				@canvas2.do
			end
			@level3 = flow() do
				@canvas3.do
			end
		end
	end

end