Pod::Spec.new do |s|
  s.name         = "KSCamera"
  s.version      = "0.1.0"
  s.summary      = "自定义相机"
  s.homepage     = "https://github.com/iCloudys/KSCamera"
  s.license      = "Apache License 2.0"
  s.author       = { "kong" => "m18301125620@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/iCloudys/KSCamera.git", :tag => "#{s.version}" }
  s.source_files  = "KSCamera", "KSCamera/*.{h,m}"
  s.resource = "KSCamera/KSCameraBundle.bundle"
  s.requires_arc = true
end
