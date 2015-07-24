class MenuBar < Basic
	attr_accessor :icons, :buttons
	def initialize a
		@a = a
		@does = Proc.new do
			@a.background @a.red
			@a.button "menu" do
				$level_2.append do 
					@a.background @a.rgb(rand(255),rand(255),rand(255))
				end
			end
		end
	end
end

class << MenuBar
	def valid_button? button_name
		if File.exist?(("Data/System/Apps/"+button_name.to_s+"/check.rb").correct_path)
			path = ("Data/System/Apps/"+button_name.to_s+"/check.rb").correct_path
		elsif File.exist?(("Data/User/Apps/"+button_name.to_s+"/check.rb").correct_path)
			path = ("Data/User/Apps/"+button_name.to_s+"/check.rb").correct_path
		else
			return false
		end
		load (path)
		return defined? app_check() && app_check()
		# Todo botão deve ser o de um App, portanto usamos o check.rb dos Apps para a verificação.
	end
end