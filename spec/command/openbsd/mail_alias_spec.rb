require 'spec_helper'

set :os, { :family => 'openbsd' }

describe get_command(:check_mail_alias_is_aliased_to, 'pink', '|/pony') do
  it do
    should eq %Q{egrep ^pink:.*\\(\\[\\[:space:\\]\\]\\|,\\)\\[\\\"\\'\\]\\?} +
              %Q{\\\\\\|/pony\\[\\\"\\'\\]\\?\\(,\\|\\$\\) } +
              %Q{/etc/mail/aliases}
  end
end

describe get_command(:check_mail_alias_is_aliased_to, 'pink', '|/pony, |/unicorn') do
  it do
    should eq %Q{egrep ^pink:.*\\(\\[\\[:space:\\]\\]\\|,\\)\\[\\\"\\'\\]\\?} +
              %Q{\\\\\\|/pony,\\\\\\ \\\\\\|/unicorn\\[\\\"\\'\\]\\?\\(,\\|\\$\\) } +
              %Q{/etc/mail/aliases}
  end
end
