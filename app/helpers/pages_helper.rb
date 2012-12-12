module PagesHelper
	#return title per Page
	def title
		@title.nil? ? "#{base_title}" : "#{base_title} | #{@title}"
	end

	def base_title
		base_title = "Sample App"
	end

	def logo
		image_tag("/images/logo.png", :alt => "Sample App", :class =>"round")
	end
end
