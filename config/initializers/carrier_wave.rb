if Rails.env.production?
	CarrierWave.configure do |config|
		config.fog_credentials = {
			:provider => 'AWS',
			:aws_access_key_id => ENV['AKIAISAKCSKGEX5RQGCA'],
			:aws_secret_access_key => ENV['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']
		}
		config.fog_directory = ENV['railsproductfirstbucket']
	end
end