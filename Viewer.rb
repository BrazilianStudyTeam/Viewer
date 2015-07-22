# Bem vindo ao BST Viewer!
# Com ele você poderá ler os arquivos da Team !
# Cuide-se :)

# PS: As hashes usarão sempre símbolos !

require 'green_shoes' # Interface gráfica utilizada
require 'json' # Para usar o JSON.Parse e a sua exception JSON:ParserError

if (File.exist?("install.ok"))
	if RUBY_PLATFORM.include?("win")
		require_relative 'Libs\\utils'
	else
		require_relative 'Libs/utils'
	end
	# o .correct_path está em utils.rb   Ele é utilizado para adaptar o path para o OS a ser utilizado. 
	
	# Os canvas são a parte básica, partes esquematicas da interface do usuário.
	require_relative 'Libs/Canvas/basic'.correct_path
	require_relative 'Libs/Canvas/main'.correct_path
	require_relative 'Libs/Canvas/information_bar'.correct_path
	require_relative 'Libs/Canvas/menu_bar'.correct_path
	require_relative 'Libs/Canvas/shell'.correct_path
	
	#As screens se carregam no canvas main.
	require_relative 'Libs/Screens/apps'.correct_path
	require_relative 'Libs/Screens/help'.correct_path
	require_relative 'Libs/Screens/home'.correct_path
	require_relative 'Libs/Screens/reader'.correct_path
	require_relative 'Libs/Screens/selector'.correct_path
	require_relative 'Libs/Screens/settings'.correct_path
	require_relative 'Libs/Screens/skills'.correct_path
	
	require_relative 'Libs/Viewer-class'.correct_path
	require_relative 'Libs/settings'.correct_path
else
	puts "Please install me before you run me. :)", "Use the install file to do this.", "install if in Unix; install.bat if in Windows"
end

load_settings
p $width      
p $height     
p $fullscreen 
p $title      
p $debug      
p $theme      
p $shell      
 
p $level_1
p $level_2
p $level_3

p $main_1
p $main_2
p $main_3
p $main_4
p $main_5
 
p $tasks_available
p $tasks_on
 
p $buttons_available
p $buttons_on
 
p $shortcuts

Viewer.new
