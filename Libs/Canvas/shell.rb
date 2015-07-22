class Shell < Basic

end

class << Shell
	def get_shell_path shell
		if File.is_valid?(("Data/System/Shells/"+shell.to_s+"_shell.rb").correct_path)
			return path = ("Data/System/Shells/"+shell.to_s+"_shell.rb").correct_path
		elsif File.is_valid?(("Data/User/Shells/"+shell.to_s+"_shell.rb").correct_path)
			return path = ("Data/User/Shells/"+shell.to_s+"_shell.rb").correct_path
		else
			return false
		end
	end

	def is_valid? shell
		if (path = get_shell_path shell)
			load (path)
			return defined? shell_do
		else
			return false
		end
	end

	def get_list
		path = "Data/User/Shells/shells.txt".correct_path
		if File.exist? (path) && (not File.zero? path)
			shell_list = []
			File.open(path).each_line do |line|
				if line[0]!="#"
					shell_list << line if Shell.exist? line
				end
			end
		else
			File.write(path, "#Shell List")
		end
	end
end