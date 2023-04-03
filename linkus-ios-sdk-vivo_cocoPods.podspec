#
#  Be sure to run `pod spec lint linkus-ios-sdk-vivo_cocoPods.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "linkus-ios-sdk-vivo_cocoPods"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of linkus-ios-sdk-vivo_cocoPods."
  spec.homepage     = "https://github.com/Yeastar-PBX/linkus-ios-sdk-vivo.git"
  spec.license      = "MIT"
  spec.author             = { "杨桂福" => "ygf@yeastar.com" }
  spec.platform     = :ios, "11.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"

  spec.source       = { :git => "https://github.com/Yeastar-PBX/linkus-ios-sdk-vivo.git", :tag => "#{spec.version}" }
  spec.source_files  = "Classes", "Classes/**/*.{h,m}"
  spec.exclude_files = "Classes/Exclude"

  spec.framework  = "YeastarLinkus"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.requires_arc = true

  spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libc++" }
  spec.dependency "AFNetworking", "~> 4.0.1"
  spec.dependency "AliyunOSSiOS", "~> 2.10.13"
  spec.dependency "OpenSSL-Universal", "~> 1.0.2.20"

end
