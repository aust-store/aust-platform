watch("spec/unit/(.+)_spec\.rb") { |m|
  system("rspec spec/unit/#{m[1]}_spec.rb")
}
watch("spec/unit/support/(.+)\.rb") { |m|
  system("rspec spec/unit/")
}
watch("spec/unit/contracts/(.+)\.rb") { |m|
  system("rspec spec/unit/")
}
watch("lib/(.+)\.rb") { |m|
  system("rspec spec/unit/lib/#{m[1]}_spec.rb")
}
watch("app/controllers/(.+)\.rb") { |m|
  system("rspec spec/unit/controllers/#{m[1]}_spec.rb")
}

