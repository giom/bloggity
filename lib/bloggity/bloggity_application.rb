require 'bloggity/page_names'

module Bloggity::BloggityApplication
	include PageNames
	
	# Implement in your application
	def current_user
		User.find(1)
	end
	
	def blog_named_link(blog, the_action = :show)
		case the_action
		when :show: "/blogs/#{blog.blog_set.url_identifier}/#{blog.url_identifier}"
		when :index: "/blogs/#{blog.blog_set.url_identifier}"
		else
			{ :controller => 'blogs', :action => the_action, :blog_set_id => blog.blog_set_id, :id => blog.id }
		end
	end
	
	# Implement in your application
	def login_required
		if current_user
      true
    else
			flash[:error] = "Login required to do this action."
			redirect_to :controller => "blogs" # Send them to wherever they login on your site...
	    false
	  end
  end
	
	# TODO: Explain how this all works
	def load_blog_set
		if(!params[:blog_set_id] && (blog_set_url_identifier = params[:blog_url_id_or_id]))
			@blog_set = BlogSet.find_by_url_identifier(blog_set_url_identifier)
		end
		@blog_set_id = params[:blog_set_id] || (@blog_set && @blog_set.id) || 1 # There is a default BlogSet created when the DB is bootstrapped, so we know we'll be able to fall back on this
		@blog_set = BlogSet.find(@blog_set_id) unless @blog_set
	end
	
	def blog_writer_or_redirect
		if @blog_set_id && current_user && current_user.can_blog?(@blog_set_id) 
			true
		else
			flash[:error] = "You don't have permission to do that."
			redirect_to :controller => "blogs" 
	    false
		end
	end
	
	def logged_in?
  	current_user && current_user.logged_in?
	end
	
  def get_page_name
  	@page_name = look_up_page_name(params[:controller], params[:action])
  end
  
  def set_page_title(title, options = {})
		@page_name = title
	end
end
