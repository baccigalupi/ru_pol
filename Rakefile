require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "ru_pol"
  gem.homepage = "http://github.com/baccigalupi/ru_pol"
  gem.license = "MIT"
  gem.summary = %Q{RuPol is a glamorous mixin for instance pooling your Ruby classes}
  gem.description = %Q{RuPol is a glamorous mixin for instance pooling your Ruby classes. 
    It eases the pain of garbarge collection for classes that are instantiated many times, and then tossed away like runway trash.
    Instances are cached on the class in a pool (array in less glamorous terms), and can be recycled at will. 
    Of course there is no pain without gain, and models will trade collection costs for memory usages.
    The Swimsuit mixin edition overrides #new and #destroy, for a virtually pain free instance swimming experience.
    Runway not included. 
  }
  gem.email = "baccigalupi@gmail.com"
  gem.authors = ["Kane Baccigalupi"]
  
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
