class Viewer
	def initialize(args = {width: 800, height: 600, title: "BST Viewer", fullscreen: false, resizable: true})
		check_settings()
		Shoes.app(width: args[:width], height: args[:height], title: args[:title], fullscreen: args[:fullscreen], resizable: args[:resizable]) {
			button("Fucks!").click{exit()}
		}
	end
end