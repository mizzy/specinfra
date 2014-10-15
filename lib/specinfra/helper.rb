require 'specinfra/helper/os'
include Specinfra::Helper::Os

require 'specinfra/helper/docker'
require 'specinfra/helper/lxc'

require 'specinfra/helper/configuration'

require 'specinfra/helper/properties'
include Specinfra::Helper::Properties

require 'specinfra/helper/host_inventory'
include Specinfra::Helper::HostInventory
