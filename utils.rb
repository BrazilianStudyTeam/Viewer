class String
	def to_b
		return true   if self == 'true'
    	return false  if self == 'false'
  	end

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
