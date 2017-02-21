Pod::Spec.new do |s|
    s.name         = "RevealableCell"
    s.version      = "2.0"
    s.summary      = "iMessage style pull-to-reveal timestamps."
    s.homepage     = "http://shaps.me/blog/imessage-style-reveal/"
    s.screenshots  = "http://shaps.me/assets/img/blog/iMessageStyleReveal@2x.jpg"
    s.license      = 'MIT'
    s.author       = { "Shaps Mohsenin" => "shapsuk@me.com" }
    s.social_media_url = "http://twitter.com/shaps"
    s.platform     = :ios
    s.platform     = :ios, '8.0'
    s.source       = { :git => "https://github.com/shaps80/iMessageStyleReveal.git", :tag => s.version.to_s }
    s.source_files  = 'Pod/Classes', '*.{h,m,swift}'
    s.requires_arc = true
end
