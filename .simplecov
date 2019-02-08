require "simplecov"
SimpleCov.start("rails") do
  add_filter("/bin/")
  add_filter("/lib/tasks/auto_annotate_models.rake")
  add_filter("/lib/tasks/coverage.rake")
  add_filter("/app/jobs")
  add_filter("/app/channels")
  add_filter("/app/mailer")
end
SimpleCov.minimum_coverage(90)
SimpleCov.use_merging(false)
