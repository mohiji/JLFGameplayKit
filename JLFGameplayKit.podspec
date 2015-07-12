Pod::Spec.new do |spec|
  spec.name = 'JLFGameplayKit'
  spec.version = '0.0.1'
  spec.summary = 'A from-scratch implementation of Apple\'s GameplayKit.'
  spec.homepage = 'https://github.com/mohiji/JLFGameplayKit'
  spec.license = 'BSD'
  spec.author = { 'Jonathan Fischer' => 'jonathan@mohiji.org' }
  spec.source = { :git => 'https://github.com/mohiji/JLFGameplayKit.git', :tag => 'v0.0.1' }
  spec.social_media_url = 'https://twitter.com/_jlfischer'

  spec.source_files = 'JLFGameplayKit/**'
  spec.public_header_files = 'JLFGameplayKit/*.h'
  spec.private_header_files = 'JLFGameplayKit/*Private.h'

  spec.osx.deployment_target = '10.9'
  spec.ios.deployment_target = '7.0'
end
