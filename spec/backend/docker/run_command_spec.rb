require "spec_helper"
require "docker"

describe "backend/docker", :docker do
  before do
    image = Docker::Image.create("fromImage" => "ubuntu")
    set :backend, :docker
    set :docker_image, image
  end

  it "can run commands" do
    command = "echo test"

    result =  Specinfra.backend.run_command(command).stdout.strip

    expect(result).to eq "test"
  end

  it "can insert files" do
    file = Tempfile.new('test')
    IO.write(file, "content\n")

    Specinfra.backend.send_file(file.path, "/test")
    result =  Specinfra.backend.run_command("cat /test").stdout.strip

    expect(result).to eq "content"
  end
end

