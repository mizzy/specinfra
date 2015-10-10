require 'spec_helper'

set :os, { :family => nil }

describe get_command(:check_mail_alias_is_aliased_to, 'pink', 'pony') do
  it do 
    should eq %Q{getent aliases pink | } +
              %Q{egrep -- \\\[\\\[:space:\\\]\\\]\\\(\\\[\\\"\\'\\\]\\?\\)pony\\\\1\\\\b}
  end 
end
