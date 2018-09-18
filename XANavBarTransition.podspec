Pod::Spec.new do |s|
  s.name         = "XANavBarTransition"
  s.version      = "1.1.2"
  s.summary      = "A simple navigation bar smooth transition library"
  s.homepage     = "https://github.com/aboutlan/XANavBarTransition"
  s.license      = "MIT"
  s.author       = { "XangAm" => "haitang_yyy@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/aboutlan/XANavBarTransition.git", :tag => s.version.to_s }
  s.source_files = "XANavBarTransition/**/*.{h,m}"
  s.requires_arc = true
end
