class String
	#retorna o path correto/corrigido para o sistema operacional
	#só é mudado as barras na prática.. Isto pois o Viewer só vai acessar de forma nativa sem decisão do usuário paths do mesmo diretório
	def correct_path
		if RUBY_PLATFORM.include? "win" #RUBY_PLATFORM -> constante do ruby com o OS utilizado
			self.gsub! "/","\\"
			if self[0]=="\\" #ou seja, se está na raiz do disco, usamos o disco C:
				return "C:"+self
			else
				return self
			end
		else #caso esteja em sistema linux/unix/mac os também, dado que o path padrão está nestes formatos
			return self
		end
	end

	#converte para boolean, se for inválido retorna nil
	def to_b
		return true   if self == 'true'
    	return false  if self == 'false'
  	end

  	#converte para Integer, caso seja inválido ou vazio retorna nil
  	def to_i 
		Integer(self || '')
		rescue ArgumentError
			nil
	end
end

class Object
	def is_boolean?
		return (self.is_a? TrueClass) || (self.is_a? FalseClass)
	end
end
