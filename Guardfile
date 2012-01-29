guard 'rspec', spec_paths: ["spec_no_rails"], :version => 2 do
  watch(%r{app/business/(.+)\.rb})    { |m| "spec_no_rails/unit/app/business/#{m[1]}_spec.rb" }
  watch(%r{app/interactors/(.+)\.rb}) { |m| ["spec_no_rails/unit/app/interactors/#{m[1]}_spec.rb", "spec_no_rails/acceptance/#{m[1]}_acceptance_spec.rb"] }
  watch(%r{spec_no_rails/(.+)_spec\.rb}) { |m| "spec_no_rails/#{m[1]}_spec.rb" }
  watch(%r{spec_no_rails/spec_helper.rb})
end