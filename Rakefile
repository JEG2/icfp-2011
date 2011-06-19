require "fileutils"

require "rake/testtask"
require "rake/packagetask"

task :default => :test
Rake::TestTask.new do |test|
	test.libs       << "src/lib" << "src/test"
	test.test_files  = %w[src/test/ts_all.rb]
	test.verbose     = true
end

#
# rm ~/Desktop/ltg.log; LOG=~/Desktop/ltg.log QUEUE=~/Desktop/queued_moves.csv \
# rk run_match
#
desc "Run game"
task :run_match do
  sh "ltg.macosx-10.6-intel -silent true match ./run ./run"
end

#
# LOG=~/Desktop/queued_moves.csv N=2 \
# rk show_log
#
desc "Show head of log"
task :show_log do
  sh "head -n ${N:-1000} ${LOG:-~/Desktop/ltg.log} | mate"
end

Rake::PackageTask.new("black_lotus", "1.0.0") do |p|
  if ARGV.first == "package"
    sh(%q{ruby -pi.bak -e 'gsub(%r{#!.+}, "#!/usr/bin/ruby1.9.1")' run})
    at_exit { FileUtils.mv("run.bak", "run") }
  end

  p.need_tar_gz = true
  p.package_files.include("install", "run", "README", "src/**/*.rb")
end
