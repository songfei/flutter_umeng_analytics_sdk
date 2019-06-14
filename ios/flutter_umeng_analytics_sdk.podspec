#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_umeng_analytics_sdk'
  s.version          = '0.0.1'
  s.summary          = 'UMeng analytics sdk.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'http://songfei.org'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'songfei' => 'songfei.org@qq.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'UMCCommon'
  s.dependency 'UMCCommonLog'
  s.dependency 'UMCSecurityPlugins'
  s.dependency 'UMCAnalytics'

  s.ios.deployment_target = '8.0'
end

