Pod::Spec.new do |s|
	s.name = 'SwiftCommonMark'
	s.version = '0.1.0'
	s.license = { :type => 'MIT', :file => 'LICENSE' }
	s.summary = 'CommonMark implementation in pure Swift'
	s.homepage = 'https://github.com/codytwinton/SwiftCommonMark'
	s.source = { :git => 'https://github.com/codytwinton/SwiftCommonMark.git', :tag => s.version.to_s }

	s.source_files = 'Sources/*.swift'
	s.ios.deployment_target = '11.0'
	s.tvos.deployment_target = '11.0'
	s.requires_arc = true

	s.social_media_url = 'http://twitter.com/codytwinton'
	s.authors = { 'Cody Winton' => 'cody.t.winton@gmail.com' }
end
