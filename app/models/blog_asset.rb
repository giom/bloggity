# == Schema Information
# Schema version: 119
#
# Table name: blog_assets
#
#  id           :integer(11)     not null, primary key
#  blog_id      :integer(11)     
#  parent_id    :integer(11)     
#  content_type :string(255)     
#  filename     :string(255)     
#  thumbnail    :string(255)     
#  size         :integer(11)     
#  width        :integer(11)     
#  height       :integer(11)     
#

class BlogAsset < ActiveRecord::Base
	belongs_to :blog_post
	
	
	has_attached_file :file, 
                    :styles => { :normal => '350x350>', 
                                 :thumb200 => '267x214' }
                          
	
	validates_attachment_presence :file
	validates_attachment_content_type :file, :content_type => ['image/jpeg', 'image/pjpeg', 'image/jpg', 'image/gif', 
	    'image/png','image/x-png','image/jpg','image/x-ms-bmp','image/bmp','image/x-bmp', 'image/x-bitmap','image/x-xbitmap',
	    'image/x-win-bitmap','image/x-windows-bmp','image/ms-bmp','application/bmp','application/x-bmp', 'application/x-win-bitmap',
	    'application/preview','image/jp_','application/jpg','application/x-jpg','image/pipeg','image/vnd.swiftview-jpeg',	
	    'image/x-xbitmap','application/png','application/x-png','image/gi_','image/x-citrix-pjpeg', 'application/pdf']
	
	validates_attachment_size :file, :less_than => 6.megabytes
	
		
end
