class InteractorGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  class_option :entities, type: :string, default: "entity_one:entity_two", description: "Define the entities involved."

  def create_interactor
    create_class
    create_acceptance_test
    create_unit_test
  end

  private

  # Prepare variables

  def entities
    options.entities.split ":"
  end

  def entities_as_phrase
    entities.join(", ")
  end

  # Generators

  def create_class
    file = <<-FILE
class #{class_name}
  attr_reader #{entities.map { |e| ':'+e}.join(", ")}

  def initialize(#{entities.join(", ")})
    #{entities.map { |e| '@'+e }.join(", ")} = #{entities.join(", ")}
  end

  def call

  end
end
    FILE
    create_file "app/interactors/#{file_name}.rb", file
  end

  # ACCEPTANCE TEST

  def entities_doubles_for_acceptance_test
    result = ""
    entities.each { |entity|
      result << <<-FILE
    @#{entity.underscore}_persistence = double("#{entity.camelize}Persistence", persist: true)
    @#{entity.underscore} = #{entity.camelize}.new(id: 1)
    @#{entity.underscore}.stub(:persistence_layer).and_return(@#{entity.underscore}_persistence)
      FILE
    }
    result
  end
  
  def create_acceptance_test
    file = <<-FILE
require "./spec_no_rails/spec_helper"

describe "#{class_name.underscore.gsub(/_/, " ")} acceptance test" do
  before do
#{entities_doubles_for_acceptance_test}
  end

  it "#{file_name.gsub(/_/, " ")}" do
    @#{entities.last}.should_receive(:persistence_layer)
    #{class_name}.new(@#{entities.first}, @#{entities.last}).call
  end

  it "" do
    # spec here...
  end
end
    FILE
    create_file "spec_no_rails/acceptance/#{file_name}_acceptance_spec.rb", file
  end

  # UNIT TEST

  def unit_test_entities_doubles
    result = ""
    entities.each_with_index { |entity, index|
      if index == 0
        result << <<-FILE
    @#{entity.underscore} = { id: 1, name: "John Doe" }
        FILE
      else
        result << <<-FILE
    @#{entity.underscore} = double("#{entity.camelize}")
    @#{entity.underscore}.stub(:add).and_return(@#{entity.underscore})
    @#{entity.underscore}.stub(:persist).and_return(true)
        FILE
      end
    }
    result
  end

  def unit_test_entity_parameters
    entities.map { |e| '[1, 2]' }.join(", ")
  end

  def create_unit_test
    file = <<-FILE
require "./spec_no_rails/spec_helper"

describe #{class_name} do
  before do
#{unit_test_entities_doubles}
  end

  it "instantiates with #{entities_as_phrase}" do
    result = #{class_name}.new(#{unit_test_entity_parameters} )
    #{entities.map { |e| 'result.'+ e.underscore}.to_s.gsub(/"/, "")}.should == [#{unit_test_entity_parameters}]
  end
end
    FILE
    create_file "spec_no_rails/unit/app/interactors/#{file_name}_spec.rb", file
  end

end
