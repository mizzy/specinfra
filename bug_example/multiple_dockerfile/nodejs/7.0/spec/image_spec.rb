require 'spec_helper'

describe "Nodejs/7.0 Specs" do

  before(:all) do
    image = Docker::Image.build_from_dir('nodejs/7.0')

    set :os, family: :debian
    set :backend, :docker
    set :docker_image, image.id
    puts Specinfra::CommandFactory.instance.inspect

  end

  # test for nodejs version
  describe command('nodejs --version') do
    its(:stdout) { should match /v7.0.0/ }
  end

  #describe command('nodejs')

end
