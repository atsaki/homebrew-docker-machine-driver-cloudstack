require "language/go"

class DockerMachineDriverCloudstack < Formula
  desc "Docker Machine generic CloudStack driver"
  homepage "https://github.com/atsaki/docker-machine-driver-cloudstack"
  url "https://github.com/atsaki/docker-machine-driver-cloudstack/archive/v0.1.2.tar.gz"
  version "v0.1.2"
  sha256 "82c54f8407ad77cc2c845873e24a6d1ffc86a30297f5d85c492d2ea48770e481"
  head "https://github.com/atsaki/docker-machine-driver-cloudstack.git"

  bottle do
    root_url "https://bintray.com/artifact/download/atsaki/bottles"
    cellar :any_skip_relocation
    sha256 "01775664442896539fd4433f3ad6dbb412d6231f5cb7657c3cb0933147aaf914" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/docker/docker" do
    url "https://github.com/docker/docker.git",
      :revision => "a34a1d598c6096ed8b5ce5219e77d68e5cd85462"
  end

  go_resource "github.com/docker/machine" do
    url "https://github.com/docker/machine.git",
      :revision => "7e8e38e1485187c0064e054029bb1cc68c87d39a"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "beef0f4390813b96e8e68fd78570396d0f4751fc"
  end

  go_resource "github.com/xanzy/go-cloudstack" do
    url "https://github.com/xanzy/go-cloudstack.git",
      :revision => "104168fa792713f5e04b76e2862779dc2ad85bcc"
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
