Gem::Specification.new do |s|
  s.name             = "tempestas"
  s.version          = "0.0.2"
  s.date             = Time.now.utc.strftime("%Y-%m-%d")
  s.homepage         = "http://github.com/athoune/ruby-tempest"
  s.authors          = "Mathieu Lecarme"
  s.email            = "mathieu@garambrogne.net"
  s.description      = "Client for the tempest cluster"
  s.summary          = s.description
  s.extra_rdoc_files = %w(README.md)
  s.files            = Dir["", "README.md", "Gemfile", "lib/**/*.rb"]
  s.require_paths    = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.add_dependency "redis", "2.2.2"
  s.add_development_dependency "rspec", "2.7"
  #s.add_development_dependency "rake"
end
