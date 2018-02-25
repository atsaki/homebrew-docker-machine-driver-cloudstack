require "language/go"

class DockerMachineDriverCloudstack < Formula
  desc "Docker Machine generic CloudStack driver"
  homepage "https://github.com/atsaki/docker-machine-driver-cloudstack"
  url "https://github.com/atsaki/docker-machine-driver-cloudstack/archive/v0.1.5.tar.gz"
  version "v0.1.5"
  sha256 "04b77ab5e1d9ed865a3ee2ad8ba4a303a54eab52f94bd4ebf3c21697ba5311aa"
  head "https://github.com/atsaki/docker-machine-driver-cloudstack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa10d26f5e9f8d51ea231e21c7216d49d220db3dcb5112874f05b3d887474a9e" => :el_capitan
  end

  depends_on "go" => :build

  go_resource "github.com/docker/docker" do
    url "https://github.com/docker/docker.git",
      :revision => "a8a31eff10544860d2188dddabdee4d727545796"
  end

  go_resource "github.com/docker/machine" do
    url "https://github.com/docker/machine.git",
      :revision => "0c3f538eb470d1546c42f82646000726e237c2b6"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "51714a8c4ac1764f07ab4127d7f739351ced4759"
  end

  go_resource "github.com/xanzy/go-cloudstack" do
    url "https://github.com/xanzy/go-cloudstack.git",
      :revision => "c815114af88405d9a8464cab25b71af3b38547c9"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["TARGET_OS"] = "darwin"

    mkdir_p buildpath/"src/github.com/atsaki/"
    ln_sf buildpath, buildpath/"src/github.com/atsaki/docker-machine-driver-cloudstack"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-i", "-o", "./bin/docker-machine-driver-cloudstack", "./bin"
    bin.install "./bin/docker-machine-driver-cloudstack"
  end

  test do
    assert_match "cloudstack-api-key", shell_output("docker-machine create -d cloudstack -h")
  end
end
