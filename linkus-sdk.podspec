Pod::Spec.new do |spec|

  spec.name         = "linkus-sdk"
  spec.version      = "1.0.12"
  spec.summary      = "为第三方应用提供Sip通话能力"

  spec.homepage     = "https://github.com/Yeastar-PBX/linkus-iOS-MacOS-sdk.git"
  spec.license      = { :type => 'MIT' }
  spec.author       = { "杨桂福" => "ygf@yeastar.com" }

  spec.source       = { :git => "https://github.com/Yeastar-PBX/linkus-iOS-MacOS-sdk.git", :tag => "#{spec.version}" }

  spec.requires_arc = true  
  spec.platform     = :ios, "11.0"
  spec.pod_target_xcconfig = { 'VALID_ARCHS[sdk=iphonesimulator*]' => '' }
  spec.vendored_frameworks ='linkus_sdk_iOS.framework'
  spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libz" }
  spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libc++" }
  spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libresolv" }

end
