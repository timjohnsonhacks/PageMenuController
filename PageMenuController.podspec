Pod::Spec.new do |s|
  s.name             = 'PageMenuController'
  s.version          = '1.0.2'
  s.summary          = 'An Android like navigation system, with a segmented control at the top, with the ability to scroll between view controllers fluidly.'

  s.description      = <<-DESC
This library allows for the creation of an Android like navigation menu on iOS. It implements a basic swipe to scroll between view controllers, with the titles of the view controllers displaying in a a bar above the content.
                       DESC

  s.homepage         = 'https://github.com/tpj3duke/PageMenuController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tim Johnson' => 'tpjohnson3691@gmail.com' }
  s.source           = { :git => 'https://github.com/tpj3duke/PageMenuController.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'PageMenuController/Classes/**/*'
  
  s.resource_bundles = {
    'PageMenuController' => ['PageMenuController/Resources/**/*.xib']
  }

  s.dependency 'SnapKit', '~> 3.0.2'
end
