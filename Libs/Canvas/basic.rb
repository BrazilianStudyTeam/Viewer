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
		return File.is_valid?(("Data/User/Themes/"+theme+"_theme.txt").correct_path) ^ File.is_valid?(("Data/System/Themes/"+theme+"_theme.txt").correct_path)
	end

	def get_theme_list
		path = "Data/User/Themes/themes.txt".correct_path
		if File.is_valid?(path)
			theme_list = []
			IO.foreach(path) do |line|
				if line.is_a_non_empty_string? && line[0]!="#" 
					theme_list << line if Basic.theme_exist? line
				end
			end
		else
			File.write(path, "#Theme List")
			return get_theme_list
		end
		return theme_list
	end
end