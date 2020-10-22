Cloudinary.config do |config|    
    config.cloud_name = ENV["CLOUD_NAME"]  
    config.api_key = ENV["CONFIG_API_KEY"]
    config.api_secret = ENV["CLOUDINARY_API_SECRET_KEY"]
    config.secure = true    
    config.cdn_subdomain = true  
 end