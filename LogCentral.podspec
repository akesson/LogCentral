Pod::Spec.new do |s|

  s.name         = "LogCentral"
  s.version      = "1.1.2"
  s.summary      = "A modern swift logging utility made for the real needs."
  s.license      = "MIT"
  s.author       = { "Henrik Akesson" => "info@akesson.mobi" }
  s.homepage     = "https://github.com/akesson/LogCentral"
  s.platforms    = { :ios => "8.0", :osx => "10.12" }
  s.source       = { :git => "https://github.com/akesson/LogCentral.git", :tag => "#{s.version}" }
  s.source_files = "Sources/**/*.swift"
end

