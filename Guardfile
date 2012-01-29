guard 'rspec', spec_paths: ["spec_no_rails"], :version => 2 do
  watch(%r{app/(business|interactors)/(.+)\.rb}) { |m| "spec_no_rails/unit/app/#{m[1]}/#{m[2]}_spec.rb" }
  watch(%r{spec_no_rails/(.+)_spec\.rb}) { |m| "spec_no_rails/#{m[1]}_spec.rb" }
  watch(%r{spec_no_rails/spec_helper.rb})
end

