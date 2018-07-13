Pod::Spec.new do |s|
  s.name           = "Francium"
  s.version        = "1.0.0"
  s.ios.deployment_target = "10.0"
  s.osx.deployment_target = "10.10"
  s.summary        = "A small library to use for your file system."
  s.author         = { "Bas van Kuijck" => "bas@e-sites.nl" }
  s.license        = { :type => "MIT", :file => "LICENSE" }
  s.homepage       = "https://github.com/e-sites/#{s.name}"
  s.source         = { :git => "https://github.com/e-sites/#{s.name}.git", :tag => s.version.to_s }
  s.source_files   = "Francium/**/*.{h,swift}"
  s.requires_arc   = true
end
