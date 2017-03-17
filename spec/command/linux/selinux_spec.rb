require 'spec_helper'

property[:os] = nil
set :os, :family => 'linux'

describe get_command(:check_selinux_has_mode, 'disabled') do
  it do
    should eq %Q{test ! -f /etc/selinux/config || ( ( (} +
              %Q{getenforce | grep -i -- disabled) ||} +
              %Q{ (getenforce | grep -i -- permissive) )} +
              %Q{ && grep -iE -- '^\\s*SELINUX=disabled\\>' /etc/selinux/config)}
  end
end

describe get_command(:check_selinux_has_mode, 'permissive', nil) do
  it do
    should eq %Q{(getenforce | grep -i -- permissive)} +
              %Q{ && grep -iE -- '^\\s*SELINUX=permissive\\>' /etc/selinux/config}
  end
end

describe get_command(:check_selinux_has_mode, 'enforcing', 'targeted') do
  it do
    should eq %Q{(getenforce | grep -i -- enforcing)} +
              %Q{ && grep -iE -- '^\\s*SELINUX=enforcing\\>' /etc/selinux/config} +
              %Q{ && grep -iE -- '^\\s*SELINUXTYPE=targeted\\>' /etc/selinux/config}
  end
end
