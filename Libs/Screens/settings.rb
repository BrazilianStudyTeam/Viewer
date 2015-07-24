# configurações
def settings_screen
	return [Proc.new do
			@b = @a.stack width: @width, height: @height do
				@a.background @a.rgb(rand(255),rand(255),rand(255))
				@a.button "Settings!" do
					@a.exit()
				end
			end
		end, @b]
end