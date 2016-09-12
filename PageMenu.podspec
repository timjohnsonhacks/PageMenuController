#
# Be sure to run `pod lib lint PageMenu.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PageMenu'
  s.version          = '0.1.0'
  s.summary          = 'An Android like navigation system, with a segmented control at the top, with the ability to scroll between view controllers fluidly.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This library allows for the creation of an Android like navigation menu on iOS. It implements a basic swipe to scroll between view controllers, with the titles of the view controllers displaying in a a bar above the content.
                       DESC

  s.homepage         = 'https://github.com/tpj3duke/PageMenu'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tim Johnson' => 'tpjohnson3691@gmail.com' }
  s.source           = { :git => 'https://github.com/tpj3duke/PageMenu.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'PageMenu/Classes/**/*'
  
  # s.resource_bundles = {
  #   'PageMenu' => ['PageMenu/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
