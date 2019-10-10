class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v1.7.1/gocryptfs_v1.7.1_src-deps.tar.gz"
  version "1.7.1"
  sha256 "d3fc2c87b869025cd51e4abea030e58e7383197a7458f26bf99a71b224402bda"

  bottle do
    cellar :any
    sha256 "056808f747a020493deb6c1674a2ef3b74d2c116e4a9844b0f07c60ebe4b9f4f" => :mojave
    sha256 "121eb6af40d9129140da6a7b5869df71e1a79f97249dbff2a835ca27983649d4" => :high_sierra
    sha256 "0a0af541c0496ea3ccf548aadaa57f6352c4ba19920c3635c53840d0f257853f" => :sierra
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on :osxfuse

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rfjakob/gocryptfs").install buildpath.children
    cd "src/github.com/rfjakob/gocryptfs" do
      system "./build.bash"
      bin.install "gocryptfs"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"encdir").mkpath
    pipe_output("#{bin}/gocryptfs -init #{testpath}/encdir", "password", 0)
    assert_predicate testpath/"encdir/gocryptfs.conf", :exist?
  end
end
