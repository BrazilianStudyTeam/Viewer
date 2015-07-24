def home_screen
	return [Proc.new do
			@b = @a.stack width: @width, height: @height do
				@a.background @a.rgb(rand(255),rand(255),rand(255))
				@a.button("Home!").click do
					@a.background @a.rgb(rand(255),rand(255),rand(255))
					@a.button("exit").click do
						@a.quit
					end
				end
			end
		end, @b]
end