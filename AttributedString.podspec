Pod::Spec.new do |s|
   s.name = 'AttributedString'
   s.version = '1.0.0'
   s.license = 'MIT'
   s.summary = 'Swift library that adds type safety and string interpolation support to NSAttributedString'
   s.homepage = 'https://github.com/indragiek/AttributedString.swift'
   s.social_media_url = 'https://twitter.com/indragie'
   s.author = 'Indragie Karunaratne'
   s.source = { :git => 'https://github.com/indragiek/AttributedString.swift/AttributedString.swift.git', :tag => s.version }
   s.source_files = 'AttributedString/*.swift'
   s.swift_version = '5.0'
   s.ios.deployment_target = '9.0'
end