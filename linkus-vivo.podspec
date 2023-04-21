Pod::Spec.new do |spec|

  spec.name         = "linkus-vivo"
  spec.version      = "0.0.19"
  spec.summary      = "为V消息提供Sip通话能力"

  spec.homepage     = "https://github.com/Yeastar-PBX/linkus-ios-sdk-vivo.git"
  spec.license      = { :type => 'MIT' }
  spec.author       = { "杨桂福" => "ygf@yeastar.com" }

  spec.source       = { :git => "https://github.com/Yeastar-PBX/linkus-ios-sdk-vivo.git", :tag => "#{spec.version}" }

  spec.requires_arc = true  
  spec.platform     = :ios, "11.0"
  spec.pod_target_xcconfig = { 'VALID_ARCHS[sdk=iphonesimulator*]' => '' }
  spec.vendored_frameworks ='linkus_vivo_iOS.framework'
  spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libc++" }
  spec.dependency "OpenSSL-Universal", "~> 1.0.2.20"

end
