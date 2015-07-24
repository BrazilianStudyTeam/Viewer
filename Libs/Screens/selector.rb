# selecionar que knowledge ver, atualizar, baixar, etc
def selector_screen
	return [Proc.new do
			@b = @a.stack width: @width, height: @height do
				@a.background @a.rgb(rand(255),rand(255),rand(255))
				@a.button "Selector!" do
					@a.exit()
				end
			end
		end, @b]
end