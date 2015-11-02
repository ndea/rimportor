Rimportor.configure do |config|
  # Configure how many threads rimportor should use for importing.
  # Consider that rimportor will use threads not only for building the statement
  # but also for running validations for your bulk.
  # The default value are 4 threads
  # config.threads = 4
end