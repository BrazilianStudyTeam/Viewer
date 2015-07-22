# setting methods
# !!! Sempre modifique este arquivo adequadamente quando adicionar mais configurações nos arquivos !!!
#  !!! Caso contrário as check_TYPE_settings vão falhar SEMPRE !!!
# ATENÇÃO! Leia acima!

$width #largura da tela
$height #altura
$title #título
$fullscreen #se fullscreen está ligado
$debug #se o debug está ligado
$canvas_sizes #o tamanho e quais objetos estão ligados em cada level
$canvas_showable #se o canvas vai estar ligado/não-oculto

# set input -> escreve no arquivo as configurações em input. Se input for igual true, reseta para as configurações default.

def load_general_settings
end

def load_gui_settings
end

def load_shortcut_settings
end

#carrega as configurações. Não faz tratamento de erro, isto é função da método check_settings, executado no início.
def load_settings
	check_settings
	if File.exist? "settings.txt"
		if File.zero? "settings.txt"
			set_default_settings
		else
			temp_canvas_size = {}
			temp_canvas_showable = {}
			File.read("settings.txt").split("\n").each do |line|
				if line[0]=="@"
					case tmp=(line=(line.slice!(1,line.length).split(":", 2))).first
						when "first", "second", "third", "fourth"
							begin
								temp_canvas_size[tmp.to_sym] = JSON.parse(line.last)
							rescue JSON::ParserError
								p "ParserError!!"
							end
					end
				elsif line[0]=="$"
					case tmp=(line=(line.slice!(1,line.length).split(":", 2))).first
						when "first", "second", "third", "fourth"
							begin
								temp_canvas_showable[tmp.to_sym] = JSON.parse(line.last)
							rescue JSON::ParserError
								p "ParserError!!"
							end
					end
				elsif line[0]=="%"
					#
				elsif line[0]!="#" && line!=""
					line.delete(' ').split(":",2).each_slice(2) do |xy|
						case xy.first
							when "width"
								$width = xy.last.to_i
							when "height"
								$height = xy.last.to_i
							when "title"
								$title = xy.last
							when "fullscreen"
								$fullscreen = xy.last.to_b
							when "debug"
								$debug = xy.last.to_b
						end
					end
				end
			end
			$canvas_sizes = temp_canvas_size
			$canvas_showable = temp_canvas_showable
		end
	else
		set_default_settings
	end
end

=begin
a tela pode ser organizada da seguinte forma:

<prompt/menu_bar/information_bar>
<main/extra> <main/extra> <main/extra> <main/extra>
<prompt/menu_bar/information_bar>
<prompt/menu_bar/information_bar>

Quatro níveis, sendo o primeiro, terceiro e quarto podendo apenas ser prompts, menu_bar e information_bar
E no segundo pode haver apenas main ou extra.
Prompt-> console de comandos
menu_bar->menu de opções
information_bar-> exibe certa informações, quando passa o mouse por cima de um objeto ou msg de aviso/loading.
main-> aqui vai ser o bruto, local onde realmente as tarefas serão feitas
extra-> aqui o usuário poderá acessar os apps que necessitar

settings {first: {}, second: {}, third: {}, fourth: {}}
=end
def check_canvas_size_settings settings
	if settings.is_a? Hash
		if settings.empty?
			return false
		else
			count  = 0
			# 'a' is to level 1,3 and 4.
			# aqui eles devem ter a mesma largura, e a altura total ocupada na var a_sum_height e deve ser == 100
			a_widths = [] #3 elementos
			a_sum_height = 0
			# 'b' is to level 2
			# devem ter a mesma altura, e a largura total ocupada na var b_sum_width e deve ser == 100
			b_heights = [] #lista de no caso 5 elementos, todos devem ser iguais, ou seja, ter altura igual
			b_sum_width = 0
			settings.keys.each do |level|
				case level.to_s
					when "first", "third", "fourth"
						if (settings[level].length == 1)
							settings[level].keys.each do |canvas_type| 
								if (["prompt", "menu_bar", "information_bar"].include? canvas_type) 
									a_widths << settings[level][canvas_type][0]
									a_sum_height += settings[level][canvas_type][1]
									count+=1
								else
									return false
								end
							end
						else
							return false
						end
					when "second"
						if settings[level].length == 5
							settings[level].keys.each do |canvas_type|
								if ["main"].include? canvas_type.to_s.split("_",2).first
									b_heights << settings[level][canvas_type][1]
									b_sum_width += settings[level][canvas_type][0]
									count+=1
								else
									return false
								end
							end
						else
							return false
						end
				end
			end
			#                 largura de lvls 'a' iguais              altura total == 100 -> 100% ocupado    alturas de lvl 'b' igual     && soma larguras de 'b' == 100
			if((count==8) && (a_widths.delete(a_widths.first) && a_widths.empty?) && ((a_sum_height+b_heights.first)==100) && (b_heights.delete(b_heights.first) && b_heights.empty?) && (b_sum_width==100))
				return true
			else
				return false
			end
		end
	else
		return false
	end
end

def check_canvas_showable_settings settings
	if ((settings.is_a? Hash) || (not settings.empty?))
		settings.keys.each do |level|
			case level.to_s
				when "first", "third", "fourth"
					if (settings[level].length==1)
						settings[level].keys.each do |canvas_type|
							if not (["prompt", "menu_bar", "information_bar"].include?(canvas_type) && settings[level][canvas_type].is_boolean?)
								return false
							end
						end
					else
						return false
					end
				when "second"
					if settings[level].length==5
						settings[level].keys.each do |canvas_type|
							if not (["main"].include?(canvas_type.split("_",2).first) && settings[level][canvas_type].is_boolean?)
								return false
							end
						end
					else
						return false
					end
			end
		end
		return true
	else
		return false
	end
end

#verifica as configurações no arquivo settings.txt; a configuração que estiver inválida será resetada (to default) caso reset==true
def check_settings
	valid_settings = if File.exist? "settings.txt"
						changed = false
						if File.zero? "settings.txt"
							set_default_settings
							true
						else
							valid_settings = { width: 1000, height: 600, fullscreen: false, title: "BSTViewer", debug: false}
							valid_canvas_size_settings = {}
							valid_canvas_size_settings_additional = {first: {prompt: [100, 7]}, second: {main_1: [70,81], main_2: [30,81], main_3: [0,81], main_4: [0,81], main_5: [0,81]}, third: {menu_bar: [100,7]}, fourth: {information_bar: [100,5]}} #para uso futuro caso a linha tenha dados errados
							valid_canvas_showable_settings = {}
							valid_canvas_showable_settings_additional = {first: {prompt:false}, second: {main_1: true, main_2: true, main_3: false, main_4: false, main_5: false}, third:{menu_bar: true}, fourth:{information_bar: true}}
							File.read("settings.txt").split("\n").each do |line|
								if line[0]=="@"
									case tmp=(line=(line.slice!(1,line.length).split(":", 2))).first
										when "first", "second", "third", "fourth"
											begin
												valid_canvas_size_settings[tmp.to_sym]=JSON.parse(line.last)
											rescue JSON::ParserError
												#se der erro, o level que está com dados errados continuará sendo o padrão
											end
									end
								elsif line[0]=="$"
									case tmp=(line=(line.slice!(1,line.length).split(":", 2))).first
										when "first", "second", "third", "fourth"
											begin
												valid_canvas_showable_settings[tmp.to_sym]=JSON.parse(line.last)
											rescue JSON::ParserError => e
											end
									end
								elsif line[0]=="%"
									#
								elsif line[0]!="#" && line!=""
									line.delete(' ').split(":",2).each_slice(2) do |xy|
										if xy.first[0]!="#"
											case xy.first
												when "width"
													if ((xy[1].to_i != nil) && (xy[1].to_i > 0))
														valid_settings[:width] = xy[1].to_i
													else
														changed = true
													end
												when "height"
													if ((xy[1].to_i != nil) && (xy[1].to_i > 0))
														valid_settings[:height] = xy[1].to_i
													else
														changed = true
													end
												when "title"
													if (xy[1]!="") && (xy[1]!=nil)
														valid_settings[:title] = xy[1]
													else
														changed = true
													end
												when "fullscreen"
													if (xy[1].respond_to?(:to_b)) && (xy[1].to_b!=nil)
														valid_settings[:fullscreen] = xy[1].to_b
													else
														changed = true
													end
												when "debug"
													if (xy[1].respond_to? :to_b) && (xy[1].to_b!=nil)
														valid_settings[:debug] = xy[1].to_b
													else
														changed = true
													end
											end
										end	
									end
								end
							end
							
							if (check_canvas_size_settings(valid_canvas_size_settings)==false)
								valid_canvas_size_settings=valid_canvas_size_settings_additional
								changed = true
							end

							if (check_canvas_showable_settings(valid_canvas_showable_settings)==false)
								valid_canvas_showable_settings=valid_canvas_showable_settings_additional
								changed = true
							end

							({misc: valid_settings, canvas_size: valid_canvas_size_settings, canvas_showable: valid_canvas_showable_settings})
						end
					else
						set_default_settings
						true
					end
	if ((!valid_settings.is_boolean?) && (changed))
		file = File.new("settings.txt", "w")
		valid_settings.keys.each do |type|
			case type
				when :misc
					valid_settings[type].keys.each do |key|
						file.write key.to_s+":"+valid_settings[type][key].to_s+"\n"
					end
				when :canvas_size
					valid_settings[type].keys.each do |key|
						file.write "@"+key.to_s+":"+valid_settings[type][key].to_json+"\n"
					end
				when :canvas_showable
					valid_settings[type].keys.each do |key|
						file.write "$"+key.to_s+":"+valid_settings[type][key].to_json+"\n"
					end
			end
		end
		file.close unless file.closed?
	elsif ((!valid_settings.is_boolean?) && (!changed))
		#puts "It's valid!"
	end
end