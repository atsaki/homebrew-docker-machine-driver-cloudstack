require "language/go"

class DockerMachineDriverCloudstack < Formula
  desc "Docker Machine generic CloudStack driver"
  homepage "https://github.com/atsaki/docker-machine-driver-cloudstack"
  url "https://github.com/atsaki/docker-machine-driver-cloudstack/archive/v0.1.4.tar.gz"
  version "v0.1.4"
  sha256 "f956a1df446aebe2edeb41033fadb97e332b61099e650a84c693ed737a1d9515"
  head "https://github.com/atsaki/docker-machine-driver-cloudstack.git"

  bottle do
    root_url "https://bintray.com/artifact/download/atsaki/bottles"
    cellar :any_skip_relocation
    sha256 "9191224b8fa0894e167f5391dd245cc4bd95871372c1e7f130481dfec01cb095" => :el_capitan
  end

  depends_on "go" => :build

  go_resource "github.com/docker/docker" do
    url "https://github.com/docker/docker.git",
      :revision => "a8a31eff10544860d2188dddabdee4d727545796"
  end

  go_resource "github.com/docker/machine" do
    url "https://github.com/docker/machine.git",
      :revision => "a650a404fc3e006fea17b12615266168db79c776"
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
