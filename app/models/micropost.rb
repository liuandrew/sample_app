class Micropost < ActiveRecord::Base
	belongs_to :user
	default_scope -> {order(created_at: :desc)}
	#connects pictures to post via :picture attribute
	mount_uploader :picture, PictureUploader
	validates :user_id, presence: true
	validates :content, presence: true, length: {maximum: 140}
	#custom validation not native to rails
	validate :picture_size

	private

		def picture_size
			if picture.size > 5.megabytes
				errors.add(:picture, "should be less than 5MB")
			end
		end
end
