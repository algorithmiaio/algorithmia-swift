#
# Be sure to run `pod lib lint algorithmia.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'algorithmia'
  s.version          = '0.1.0'
  s.summary          = 'Client for calling algorithms hosted on the Algorithmia marketplace'
  s.description      = <<-DESC
The Algorithmia Swift client provides Swift and iOS developers
access to over 2,500 algorithmic microservices spanning categories
from machine learning, natural language processing, computer vision,
and many other areas of algorithm development. 

Use the Algorithmia Swift client to add machine intelligence
to your iOS or Swift applications.
                       DESC

  s.homepage         = 'https://github.com/algorithmiaio/algorithmia-swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors           = { 'Erik Ilyin' =>'erik.ilyin@aol.com', 'Algorithmia' => 'devops@algorithmia.com' }
  s.source           = { :git => 'https://github.com/algorithmiaio/algorithmia-swift.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/algorithmia'

  s.ios.deployment_target = '8.0'

  s.source_files  = 'Algorithmia/*.{swift}', 'Algorithmia/**/*.{swift}','Algorithmia/Client/Auth/*.{swift}'
  
  # s.resource_bundles = {
  #   'algorithmia' => ['algorithmia/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
