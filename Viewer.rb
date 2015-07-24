#!/usr/local/bin/ruby
# Bem vindo ao BST Viewer!
# Com ele você poderá ler os arquivos da Team !
# Cuide-se :)

# PS: As hashes usarão sempre símbolos !

# Settings from files - configurações obtidas por meio dos arquivos de configuração
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
			$level_1_h = 0
			$level_2_h = 0
			$level_3_h = 0
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
	# Já vamos dá require nelas de uma vez para não ficar dando load somente quando for usar... perdendo tempo.
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
Viewer.new
