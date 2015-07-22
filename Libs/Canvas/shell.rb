class Shell < Basic

end

class << Shell
	def exist? shell
		return get_list.include?(theme)
	end

	def get_list
		path = "Data/User/Shells/shells.txt".correct_path
		if File.exist? (path) && (not File.zero? path)
			shell_list = []
			File.open(path).each_line do |line|
				if line[0]!="#"
					shell_list << line if File.exist?(("Data/User/Shells/"+line+".txt").correct_path ^ ("Data/System/Themes/"+line+".txt").correct_path)
				end
			end
		else
			File.write(path, "#Shell List")
		end
	end
end