require_relative 'lib/singleton_class_helpers/version'

Gem::Specification.new do |spec|
  spec.name          = "singleton_class_helpers"
  spec.version       = SingletonClassHelpers::VERSION
  spec.authors       = ["Marcos Essindi"]
  spec.email         = ["marcessindi@icloud.com"]

  spec.summary       = "Utility methods for singleton classes"
  spec.homepage      = "https://github.com/dunkelbraun/singleton_class_helpers"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/dunkelbraun/singleton_class_helpers"
  spec.metadata["changelog_uri"] = "https://github.com/dunkelbraun/singleton_class_helpers/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
