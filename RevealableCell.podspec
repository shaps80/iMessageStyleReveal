Pod::Spec.new do |s|
    s.name         = "RevealableCell"
    s.version      = "2.5.2"
    s.swift_versions = ["5.1"]
    s.summary      = "iMessage style pull-to-reveal timestamps."
    s.homepage     = "https://github.com/shaps80/iMessageStyleReveal"
    s.license      = 'MIT'
    s.author       = { "Shaps Benkau" => "shapsuk@me.com" }
    s.social_media_url = "http://twitter.com/shaps"
    s.platform     = :ios
    s.platform     = :ios, '10.0'
    s.source       = { :git => "https://github.com/shaps80/iMessageStyleReveal.git", :tag => s.version.to_s }
    s.source_files  = 'Pod/Classes', '*.{h,m,swift}'
    s.requires_arc = true
end
