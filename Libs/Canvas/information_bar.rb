class InformationBar < Basic
	@tasks = false
	def initialize a
		@a = a
		@does = Proc.new do 
			@a.background @a.black
			@a.button "information" do
				$level_3.append do 
					@a.background @a.rgb(rand(255),rand(255),rand(255))
				end
			end
		end
	end
end

class << InformationBar
	# não pode ter tasks com nomes iguais. Tasks do sistema terão preferência.
	def get_task_path task_name
		if File.exist?(("Data/System/Tasks/"+task_name.to_s+"/").correct_path)
			return path = ("Data/System/Tasks/"+task_name.to_s+"/").correct_path
		elsif File.exist?(("Data/User/Tasks/"+task_name.to_s+"/").correct_path)
			return path = ("Data/User/Tasks/"+task_name.to_s+"/").correct_path
		else
			return false
		end
	end

	def valid_task? task_name
		if not ((path = get_task_path(task_name)).is_boolean?)
			load (path+"check.rb")
			return defined?(task_check()) && task_check()
			# toda task deve ter um arquivo check.rb com o método "task_check" para checar suas dependências.
		else
			return false
		end
	end

	def task_activated? task_name
		File.foreach("Data/User/Tasks/tasks.txt".correct_path) do |line|
			if (line.chomp != "") && line[0]!="#"
				if not $tasks_on.empty?
					return false if not $tasks_on.include? task_name
				end
			end
		end
		return true
	end

	def load_activated_tasks
		File.foreach("Data/User/Tasks/tasks.txt".correct_path) do |line|
			if (line.chomp != "") && line[0]!="#"
				line = line.chomp
				if (InformationBar.valid_task?(line))
					path = get_task_path(line)+"does.rb"
					load (path)
					if defined?(does) && (does.is_a? Proc)
						$tasks_on[line.to_sym] = does
					else
						puts "é ferro!"
					end
				else
					puts line, "is a invalid task!"
				end
			end
		end
	end
end