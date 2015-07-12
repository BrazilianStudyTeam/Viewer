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

place = 'Home'

Shoes.app {
	background white
	stack do
	flow do 
	@text = edit_line
	@pull = button "Hey!"
end
	@note = para "Hello World!"
end

	@pull.click {@note.replace @text.text()}
}