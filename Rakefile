require 'rspec/core/rake_task'

task 'default' => 'test:spec'

namespace :test do
  desc "Run tests"
  RSpec::Core::RakeTask.new('spec') do |t|
    t.pattern = 'spec/**/*_spec.rb'
  end
  
  namespace :spec do
    RSpec::Core::RakeTask.new('rcov') do |t|
      t.pattern = 'spec/**/*_spec.rb'
      t.rcov = true
    end
  end
end

namespace :docs do
  begin
    require 'yard'
  rescue LoadError
    require 'rdoc/task'
    RDoc::Task.new('all') do |t|
      t.rdoc_dir = 'doc'
      t.main = 'README.md'
      t.rdoc_files.include 'README.md', 'lib/**/*.rb'
      t.options << '--inline-source'
      t.options << '--line-numbers'
      t.options << '--all'
    end
    
    RDoc::Task.new('public') do |t|
      t.rdoc_dir = 'doc'
      t.main = 'README.md'
      t.rdoc_files.include 'README.md', 'lib/**/*.rb'
      t.options << '--inline-source'
      t.options << '--line-numbers'
    end
  else
    YARD::Rake::YardocTask.new('all') do |t|
      t.files = ['./lib/**/*.rb']
      t.options = %w{--main README.md --private --protected --no-stats --hide-void-return}
    end
    
    YARD::Rake::YardocTask.new('public') do |t|
      t.files = ['./lib/**/*.rb']
      t.options = %w{--main README.md --no-private --no-stats --hide-void-return}
    end
  end
end