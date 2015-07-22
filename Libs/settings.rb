# nos app por um need_reinstall rebuild...

# General Settings
	$width      = 0
	$height     = 0
	$fullscreen = nil
	$title      = nil
	$debug      = nil
	$theme      = nil
	$shell      = nil

# Gui (all gui) Settings
	# Levels height
		$level_1 = 0
		$level_2 = 0
		$level_3 = 0
	# Mains settings
		$main_1 = {}
		$main_2 = {}
		$main_3 = {}
		$main_4 = {}
		$main_5 = {}
	# Tasks
		$tasks_available = []
		$tasks_on        = {}
	# Menu_bar
		$buttons_available = {}
		$buttons_on        = {}

# ShortCut Settings
	$shortcuts = {}

# SET   -> Se o argumento for:
			# => true
				# => volta para as configurações default.
			# => hash
				# => as configurações passadas pela hash serão gravadas.
# CHECK -> Verifica se a configuração é válida, caso contrário retorna esta para a versão default.
# LOAD  -> Carrega as configurações no Viewer. Antes disso é usado a função CHECK.

def set_settings i
	if i==true
		return (set_general_settings true) && (set_gui_settings true) && (set_menu_bar_settings true) && (set_shortcut_settings true)
	elsif (i.is_a? Hash) && (i.length == 4)
		return (set_general_settings i[:general]) && (set_gui_settings i[:gui]) && (set_menu_bar_settings i[:menu]) && (set_shortcut_settings i[:shortcut])
	else
		return false
	end
end

def check_settings
	return (check_gui_settings && check_general_settings && check_menu_bar_settings && check_shortcut_settings)
end

def load_settings
	return (load_gui_settings && load_general_settings && load_menu_bar_settings && load_shortcut_settings)
end

def set_general_settings input
	path = "Data/User/Settings/general_settings.txt".correct_path
	if (input==true)
		File.write(path, File.read("Data/System/Default_Settings/general_settings.txt".correct_path))
	else
		file = File.open(path, "w")
		input.keys do |key|
			file.write(key.to_s+":"+input[key].to_s+"\n")
		end
		file.close unless file.closed?
	end
	return true
end

def check_general_settings
	path = "Data/User/Settings/general_settings.txt".correct_path
	if File.is_valid? path
		temp_general_settings = {}
		IO.foreach(path) do |line|
			line = line.chomp.strip.split(":",2)
			line[1].strip! if line[1].is_a_non_empty_string?
			case line[0]
				when "width"
					return false if line[1].to_i<=0
					temp_general_settings[:width] = nil # Apenas para armazenas o width, isto pois chaves não se repetem, mas valores de lista podem.
				when "height"
					return false if line[1].to_i<=0
					temp_general_settings[:height] = nil
				when "fullscreen"
					return false if line[1].to_b==nil
					temp_general_settings[:fullscreen] = nil
				when "title"
					return false if not line[1].is_a_non_empty_string?
					temp_general_settings[:title] = nil
				when "debug"
					return false if line[1].to_b==nil
					temp_general_settings[:debug] = nil
				when "theme"
					return false if (not Basic.theme_exist?(line[1]))
					temp_general_settings[:theme] = nil
				when "shell"
					return false if (not Shell.is_valid?(line[1]))
					temp_general_settings[:shell] = nil
			end
		end
		if (temp_general_settings.length == 7) # Cuidado !
			return true
		else
			return false
		end
	else
		set_general_settings true
		check_general_settings
	end
end

def load_general_settings
	if (check_general_settings)
		File.foreach("Data/User/Settings/general_settings.txt".correct_path) do |line|
			line = line.chomp.strip.split(":", 2)
			line[1].strip! if line[1].is_a_non_empty_string?
			case line[0]
				when "width"
					$width = line[1].to_i
				when "height"
					$height = line[1].to_i
				when "fullscreen"
					$fullscreen = line[1].to_b
				when "title"
					$title = line[1]
				when "debug"
					$debug = line[1].to_b
				when "theme"
					$theme = line[1]
				when "shell"
					$shell = line[1]
			end
		end
		return true
	else
		set_general_settings true
		load_general_settings
	end
end

def set_gui_settings input
	path = "Data/User/Settings/gui_settings.txt".correct_path
	if (input==true)
		File.write(path, File.read("Data/System/Default_Settings/gui_settings.txt".correct_path))
	else
		file = File.open(path, "w")
		input.keys do |key|
			input[key].keys do |name|
				case key
					when :level
						file.write("@"+name.to_s+":"+input[key][name].to_s+"\n")
					when :mains
						file.write("$"+name.to_s+":"+input[key][name].to_json+"\n")
					when :tasks
						file.write("&"+name.to_s+":"+input[key][name].to_json+"\n")
				end
			end
		end
		file.close unless file.closed?
	end
	return true
end

def check_gui_settings
	path = "Data/User/Settings/gui_settings.txt".correct_path
	if File.is_valid? path
		temp_level_settings = {}
		temp_mains_settings = {}
		temp_tasks_settings = []
		re = {}
		sum_vertical = 0
		sum_horizontal = 0
		view_type = "" # se está carregando um main vertical ou horizontal
		number_horizontal = 0
		IO.foreach(path) do |line|
			line = parseSettings(line.chomp.strip)
			case line[0][0]
				when "@"
					return false if (not ["level_1", "level_2", "level_3"].include?(line[0][1])) || (not line[1].to_i>0)
					temp_level_settings[line[0][1].to_sym]=line[1].to_i
				when "$"
					return false if (not ["main_1", "main_2", "main_3", "main_4", "main_5"].include?(line[0][1])) || 
						(not (tmp = lambda {
							| valid_line = lambda {
						 		| parsed_line = begin; return JSON.parse(line[1]);rescue JSON::ParserError; return false; end |
						 		if ((parsed_line.is_a? Hash) && (not re.empty?) && (re.keys.length==5)); return parsed_line; else; return false; end}.call |
							if (valid_line!=false)
					 			valid_line.keys.each { |k| return false if (not ["activated", "showable", "screen", "mode", "size"].include?(k)) || 
					 				(not (case k
					 						when "activated", "showable"
					 							valid_line[k].is_boolean?
					 						when "screen"
					 							["help", "home", "reader", "settings", "skills", "selector"].include?(valid_line[k])
					 						when "mode"
					 							case tmp=(valid_line[k]=valid_line[k].split("_", 2))[0]
					 								when "vertical"
					 									view_type = "vertical"
					 									true
					 								when "horizontal"
					 									if (valid_line[k][1].to_i > number_horizontal) && (valid_line[k][1].to_i > 0)
					 										number_horizontal=valid_line[k][1].to_i
					 										view_type = "horizontal"
					 										true
					 									else
					 										true
					 									end
					 								else
					 									return false
					 							end
					 						when "size"
					 							case view_type
						 							when "vertical"
						 								#sum_vertical+=valid_line[k].to_i if (valid_line[k].is_a? Fixnum) && (valid_line[k]>0)
						 								true
						 							when "horizontal"
						 								if (valid_line[k][1] > 0)
						 									sum_horizontal+=valid_line[k][1].to_i
						 									number_horizontal-=1

						 									if ((number_horizontal==0) && (sum_horizontal != 100))
						 										return false
						 									else
						 										true
						 									end
						 								else
						 									true
						 								end
					 							end
					 					  end))}
								return valid_line
							else; return false; end; }).call)
					temp_mains_settings[line[0][1].to_sym]=tmp
				when "&"
					return false if (not ["tasks_available"].include?(line[0][1])) ||
						(not (lambda { 
							begin
								line[1] = JSON.parse(line[1])
								line[1].each do |task_name|
									if not InformationBar.valid_task?(task_name)
										return false
									end
								end
								return true
							rescue JSON::ParserError
								return false
							end}).call)
					temp_tasks_settings = line[1].map &:to_sym
			end
		end
		# Verifica se há alguma task on/ativada, porém não listada na lista de tasks disponíveis.
		InformationBar.load_activated_tasks()
		if (lambda { $tasks_on.keys.each do |task_on|
				if (not temp_tasks_settings.include?(task_on)); return true; else; return false; end;
			end}.call)
			return false
		end

		# Vê o tamanho de cada hash (configuração), se está todas as configurações registradas:
		if (temp_mains_settings.length==5) && (temp_level_settings.length==3)
			return true
		else
			return false
		end
	else
		set_gui_settings true
		check_gui_settings
	end
end

def load_gui_settings
	if (check_gui_settings)
		File.foreach("Data/User/Settings/gui_settings.txt".correct_path) do |line|
			line = parseSettings(line.chomp.strip)
			case line[0][0]
				when "@"
					case line[0][1]
						when "level_1"
							$level_1 = line[1].to_i
						when "level_2"
							$level_2 = line[1].to_i
						when "level_3"
							$level_3 = line[1].to_i
					end
				when "$"
					case line[0][1]
						when "main_1"
							$main_1 = JSON.parse(line[1])
						when "main_2"
							$main_2 = JSON.parse(line[1])
						when "main_3"
							$main_3 = JSON.parse(line[1])
						when "main_4"
							$main_4 = JSON.parse(line[1])
						when "main_5"
							$main_5 = JSON.parse(line[1])
					end
				when "&"
					case line[0][1]
						when "tasks_available"
							$tasks_available = JSON.parse(line[1])
					end
			end
		end
		return true
	else
		set_gui_settings true
		load_gui_settings
	end
end

def set_menu_bar_settings input
	path = "Data/User/Settings/menu_bar_settings.txt".correct_path
	if (input == true)
		File.write(path, File.read("Data/System/Default_Settings/menu_bar_settings.txt".correct_path))
	else
		file = File.open(path, "w")
		input.keys do |key|
			input[key].keys do |name|
				case key
					when :menu
						file.write("&"+name.to_s+":"+input[key][name].to_json+"\n")
					when :buttons
						file.write("§"+name.to_s+":"+input[key][name].to_s+"\n")
				end
			end
		end
		file.close unless file.closed?
	end
	return true
end

def check_menu_bar_settings
	path = "Data/User/Settings/menu_bar_settings.txt".correct_path
	if (File.is_valid? path)
		File.foreach(path) do |line|
			line.chomp!.strip!
			line = parseSettings(line)
			case line[0][0]
				when "&"
					return false if (not ["buttons_available"].include? line[0][1]) || ( not 
						begin
							return JSON.parse(line[1]).each do |button_name|
								return false if not MenuBar.valid_button? button_name
							end
						rescue JSON::ParserError
							return false
						end
						)
				when "§"
					return false if not (line[1]=="system" || line[1]=="user")
			end
		end
		return true
	else
		set_menu_bar_settings true
		check_menu_bar_settings
	end
end

def load_menu_bar_settings
	if (check_menu_bar_settings)
		File.foreach("Data/User/Settings/menu_bar_settings.txt".correct_path) do |line|
			line.chomp!.strip!
			line = parseSettings(line)
			case line[0][0]
				when "&"
					case line[0][1]
						when "buttons_available"
							$buttons_available = JSON.parse(line[1])
					end
				when "§"
					$buttons_on[line[0][1].to_sym] = line[1]
			end
		end
		return true
	else
		set_menu_bar_settings true
		load_menu_bar_settings
	end
end

def set_shortcut_settings input
	path = "Data/User/Settings/shortcut_settings.txt".correct_path
	if (input==true)
		File.write(path, File.read("Data/System/Default_Settings/shortcut_settings.txt".correct_path))
	else
		file = File.open(path, "w")
		input.keys do |key|
			file.write("%"+key.to_s+":"+input[key].to_s+"\n")
		end
		file.close unless file.closed?
	end
	return true
end

# Não verifica se tem todos os atalhos registrados. Apenas se não repete os comandos dos atalhos.
def check_shortcut_settings
	path = "Data/User/Settings/shortcut_settings.txt".correct_path
	if File.is_valid? path
		temp_shortcut_settings = {}
		File.foreach(path) do |line|
			line = parseSettings(line.chomp.strip)
			if (line[0][0]=="%")
				line[1].strip!
				if line[0][1].is_a?(String) && (not temp_shortcut_settings.values.include?(line[1]))
					temp_shortcut_settings[line[0][1]] = line[1]
				else
					return false
				end
			end
		end
		return true
	else
		set_shortcut_settings true
		check_shortcut_settings
	end
end

def load_shortcut_settings
	if (check_shortcut_settings)
		File.foreach("Data/User/Settings/shortcut_settings.txt".correct_path) do |line|
			line = parseSettings(line.chomp.strip)
			if (line[0][0]=="%")
				$shortcuts[line[0][1]]=line[1].strip
			end
		end
		return true
	else
		set_shortcut_settings true
		load_shortcut_settings
	end
end