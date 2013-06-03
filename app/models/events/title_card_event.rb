class TitleCardEvent < Event


	def self.text t
		self.new(:text=>t)
	end


end