require 'hocon'

ObjectSpace.each_object(Class) { |k| puts k.name }

# ArgumentError: wrong number of arguments (0 for 1)
# from /home/chem/.gem/ruby/gems/hocon-0.9.5/lib/hocon/impl/token_type.rb:24:in `name'
