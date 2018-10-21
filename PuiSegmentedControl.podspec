Pod::Spec.new do |s|
  s.name = 'PuiSegmentedControl'
  s.version = '1.0.1'
  s.license = 'MIT'
  s.summary = 'PuiSegmentedControl is a customizable for segmented control'
  s.homepage = 'https://github.com/kbakacak/PuiSegmentedControl'
  s.authors = { 'Kemal Bakacak' => 'hi@kemalbakacak.com' }
  s.source = { :git => 'https://github.com/kbakacak/PuiSegmentedControl.git', :tag => s.version }
  s.swift_version = '4.0'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Source/*.{h,m,swift}'
end
