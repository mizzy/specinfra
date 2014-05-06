require 'specinfra/helper/os'
require 'specinfra/helper/detect_os'

require 'specinfra/helper/backend'
include Specinfra::Helper::Backend

require 'specinfra/helper/docker'
require 'specinfra/helper/lxc'

require 'specinfra/helper/configuration'

require 'specinfra/helper/properties'
include Specinfra::Helper::Properties
