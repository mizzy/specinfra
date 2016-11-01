require 'serverspec'
require 'docker'

DOCKER_FOLDER = "python/2.7"
describe "Python/2.7 Specs" do

  before :all do
    image = Docker::Image.build_from_dir(DOCKER_FOLDER,  ARG: 'requirements.txt')

    set :path, '/usr/local/bin:$PATH'
    set :os, family: :alpine
    set :backend, :docker
    set :docker_image, image.id
    puts Specinfra::CommandFactory.instance.inspect
  end

  #test for python version 2.7
  it 'has python 2.7 installed' do
    expect(command('python -c "import sys; print(sys.version_info[:])"').stdout).to include\
      '2, 7'
  end
end
