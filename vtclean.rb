class Vtclean < Formula
  desc "Tool for cleaning up terminal output"
  url "https://github.com/lunixbochs/vtclean.git",
      :tag => "v1.0.0"

  depends_on "go" => :build

  def install
    system "go", "install", "github.com/lunixbochs/vtclean/vtclean@v1.0.0"
    bin.install "#{ENV["GOPATH"]}/bin/vtclean"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/vtclean --help")
  end
end

