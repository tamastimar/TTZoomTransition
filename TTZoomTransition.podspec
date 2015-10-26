Pod::Spec.new do |s|
  s.name         = 'TTZoomTransition'
  s.version      = '1.0.2'
  s.authors      = { 'Tamás Tímár' => 'hello@tamastimar.com' }
  s.homepage     = 'https://github.com/tamastimar/TTZoomTransition'
  s.platform     = :ios
  s.summary      = 'A simple custom modal view controller transition.'
  s.source       = { :git => 'https://github.com/tamastimar/TTZoomTransition.git', :tag => s.version.to_s }
  s.license      = 'MIT'
  s.frameworks   = 'UIKit'
  s.source_files = 'TTZoomTransition'
  s.requires_arc = true
  s.ios.deployment_target = '7.0'
  s.screenshot  = 'https://raw.githubusercontent.com/tamastimar/TTZoomTransition/assets/ttzoomtransition-screenshot.gif'
end
