Pod::Spec.new do |spec|

  spec.name         = "linkus-sdk-MacOS"
  spec.version      = "1.0.18"
  spec.summary      = "为V消息提供Sip通话能力"

  spec.homepage     = "https://github.com/Yeastar-PBX/linkus-iOS-MacOS-sdk.git"
  spec.license      = { :type => 'MIT' }
  spec.author       = { "杨桂福" => "ygf@yeastar.com" }

  spec.source       = { :git => "https://github.com/Yeastar-PBX/linkus-iOS-MacOS-sdk.git", :tag => "#{spec.version}" }

  spec.requires_arc = true  
  spec.platform     = :osx, "10.13"
  spec.vendored_frameworks ='linkus_sdk_MacOS.framework'
  spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/curl" }
  spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libc++" }

end
