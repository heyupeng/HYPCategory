#
# Be sure to run `pod lib lint HYPCategory.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HYPCategory'
  s.version          = '1.0.2'
  s.summary          = 'A short description of HYPCategory.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
1. CoreBluetooth:
  CBManager: iOS 13授权状态兼容；

2. CoreGraphics:
 Geometry: 增加 CGPoint, CGSize, CGRect 几何计算函数;
 
3. Foundation:
  NSArray: 防越界处理, 数组闭环索引处理；
  NSString: MD5编码, HexString, 数基转换（2、10、16进制）;
  NSData: 数据流与16进制字符串的转换, Crypto加密解密;
  NSDate: 日期格式化的转换与输出, 日期组成零件;

4. UIKit:
  UIDevice: 型号识别;
  UIImage: 图像截取, 图像叠加合并;
  UIScreen: 缺口屏判断;
  UIApplication: iOS 13状态栏API变更兼容, 安全区域获取;
  
                       DESC

  s.homepage         = 'https://github.com/heyupeng/HYPCategory'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'heyupeng' => '13750523250@163.com' }
  s.source           = { :git => 'https://github.com/heyupeng/HYPCategory.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HYPCategory/Classes/**/*'
  
  # s.resource_bundles = {
  #   'HYPCategory' => ['HYPCategory/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Enumability', '~> 1.0.1'
end
