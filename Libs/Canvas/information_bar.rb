class InformationBar < Basic
	@tasks = false
end

class << InformationBar
	def valid_task? task_name
		if File.exist(("Data/System/Tasks/"+task_name.to_s+"/check.rb").correct_path)
			path = ("Data/System/Tasks/"+task_name.to_s+"/check.rb").correct_path
		elsif File.exist(("Data/User/Tasks/"+task_name.to_s+"/check.rb").correct_path)
			path = ("Data/User/Tasks/"+task_name.to_s+"/check.rb").correct_path
		else
			return false
		end
		load (path)
		return defined? task_check() && task_check()
		# toda task deve ter um arquivo check.rb com o método "task_check" para checar suas dependências.
	end

	def task_activated? task_name
		File.foreach("Data/User/Tasks/tasks.txt".correct_path) do |line|
			if (line.chomp != "") && line[0]!="#"
				if not $tasks_available.empty?
					return false if not $tasks_available.include? task_name
				end
			end
		end
		return true
	end

	def load_activated_tasks
		File.foreach("Data/User/Tasks/tasks.txt".correct_path) do |line|
			if (line.chomp != "") && line[0]!="#"
				$tasks_available << line
			end
		end
	end
end