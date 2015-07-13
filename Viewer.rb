# Bem vindo ao BST Viewer!
# Com ele você poderá ler os arquivos da Team !
# Cuide-se :)

require 'shoes'

require 'screens/help'
require 'screens/home'
require 'screens/reader'
require 'screens/selector'
require 'screens/settings'
require 'screens/skills'

require "Viewer-class"
require 'settings-db'
require 'utils'

load_settings #carrega as configurações para poder então iniciar o Viewer
Viewer.new({width: 800, height: 100})
