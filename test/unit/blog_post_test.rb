require File.dirname(__FILE__) + '/../test_helper'

class BlogPostTest < ActiveSupport::TestCase
	def authorized_to_blog_to(blog_post, authorized = true)
		user = blog_post.posted_by
		user.instance_eval <<-IEVAL
		def can_blog?(blog_id = nil)
			#{authorized}
		end
IEVAL
	end
	
	
	# Test our validations for new blogs
	def test_create
		blog_post = get_fixture(BlogPost, "blog_post_valid_and_posted")

		authorized_to_blog_to(blog_post)
		
		assert blog_post.valid?
		
		blog_post.blog_id = nil
		assert !blog_post.valid?
		assert blog_post.errors.on(:blog_id)
		
		blog_post = get_fixture(BlogPost, "blog_post_valid_and_posted")
		authorized_to_blog_to(blog_post, false)
		

		assert !blog_post.valid?
		assert blog_post.errors.on(:posted_by_id)
	end
	
	def test_url_identifier
		blog_post = get_fixture(BlogPost, "blog_post_valid_and_posted")
		blog_post.is_complete = false
		blog_post.title = "My first blog"
		blog_post.url_identifier = "My_first_blog"
		blog_post.save
		
		blog_post.is_complete = true
		blog_post.title = "My second blog"
		blog_post.save
		assert_equal blog_post.url_identifier, "My_first_blog"
	end
	
	def test_tag_creation
		blog_post = get_fixture(BlogPost, "blog_post_valid_and_posted")
		authorized_to_blog_to(blog_post)

		blog_post.tag_string = "Pony, horsie, doggie"
		blog_post.save
		assert_equal blog_post.tags.size, 3
		
		blog_post.tag_string = "Parrot"
		blog_post.save
		assert_equal blog_post.tags.size, 1
	end
end
