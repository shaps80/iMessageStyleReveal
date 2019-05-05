Pod::Spec.new do |s|
    s.name         = "RevealableCell"
    s.version      = "2.5"
    s.summary      = "iMessage style pull-to-reveal timestamps."
    s.homepage     = "https://github.com/shaps80/iMessageStyleReveal"
    s.screenshots  = "<INSERT_URL_HERE>"
    s.license      = 'MIT'
    s.author       = { "Shaps Mohsenin" => "shapsuk@me.com" }
    s.social_media_url = "http://twitter.com/shaps"
    s.platform     = :ios
    s.platform     = :ios, '8.0'
    s.source       = { :git => "https://github.com/shaps80/iMessageStyleReveal.git", :tag => s.version.to_s }
    s.source_files  = 'Pod/Classes', '*.{h,m,swift}'
    s.requires_arc = true
end
