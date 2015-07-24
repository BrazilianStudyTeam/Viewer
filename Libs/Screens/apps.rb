def app_screen
	return [Proc.new do
			@b = @a.stack width: @width, height: @height do
				@a.background @a.rgb(rand(255),rand(255),rand(255))
				@a.button "Apps!" do
					@a.exit()
				end
			end
		end, @b]
end