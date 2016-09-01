Gem::Specification.new do |spec|
  spec.name          = 'seeds'
  spec.version       = '1.0.0'
  spec.authors       = ['Isaiah Soung']
  spec.date          = '2016-08-09'
  spec.summary       = 'Seeds is a plug&play persistent storage for Ruby'
  spec.homepage      = 'https://github.com/Isoung/pinecone'
  spec.files         = [
    'lib/crud.rb',
    'lib/leaf.rb',
    'lib/response.rb',
    'lib/seeds.rb',
    'README.md'
  ]
  spec.add_runtime_dependency 'lru_redux', '~>1.1.0'
  spec.add_development_dependency 'rubocop', '~>0.41.1'
  spec.add_development_dependency 'rspec', '~>3.5.0'
end
