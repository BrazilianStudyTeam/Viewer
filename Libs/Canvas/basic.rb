class Basic
	attr_accessor :width, :height, :showable
	@a # @app
	@do

	def initialize app
		@a = app
		@do = Proc.new do
			@a.background @a.black
		end
	end

	def does
		@do.call if @do.is_a? Proc
	end
end

class << Basic
	def theme_exist? theme
		return get_theme_list.include?(theme)
	end

	def get_theme_list
		path = "Data/User/Themes/themes.txt".correct_path
		if File.exist? (path) && (not File.zero? path)
			theme_list = []
			File.open(path).each_line do |line|
				if line[0]!="#"
					theme_list << line if File.exist?(("Data/User/Themes/"+line+".txt").correct_path ^ ("Data/System/Themes/"+line+".txt").correct_path)
				end
			end
		else
			File.write(path, "#Theme List")
		end
	end
end