require 'specinfra/helper/os'
include Specinfra::Helper::OS

require 'specinfra/helper/backend'
include Specinfra::Helper::Backend

require 'specinfra/helper/docker'
require 'specinfra/helper/lxc'

require 'specinfra/helper/configuration'

require 'specinfra/helper/properties'
include Specinfra::Helper::Properties

require 'specinfra/helper/set'
include Specinfra::Helper::Set
