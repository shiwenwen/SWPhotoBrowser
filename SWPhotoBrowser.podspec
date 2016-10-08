
Pod::Spec.new do |s|

  s.name         = "SWPhotoBrowser"
  s.version      = "1.0.1"
  s.summary      = "仿微博，朋友圈的图片浏览，功能丰富"

  s.description  = <<-DESC
            仿微博，朋友圈的图片浏览，效果不错，功能丰富，使用简单。
                   DESC

  s.homepage     = "https://github.com/shiwenwen/SWPhotoBrowser"
  s.screenshots  = "https://raw.githubusercontent.com/shiwenwen/SWPhotoBrowser/master/SWPhotoBrowser.gif"

  s.license      =  { :type => "MIT", :file => "LICENSE" }
  s.author             = { "石文文" => "shiwenwenDevelop@163.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/shiwenwen/SWPhotoBrowser.git", :tag => "1.0.0" }
  s.source_files  = "SWPhotoBrowser", "SWPhotoBrowser/SWPhotoBrowser/*.{h,m}"
  s.framework  = "UIKit"
  s.dependency "SDWebImage"

end
