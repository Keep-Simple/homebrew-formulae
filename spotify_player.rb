class SpotifyPlayer < Formula
  desc "Command driven Spotify player"
  homepage "https://github.com/aome510/spotify-player"
  head "https://github.com/aome510/spotify-player.git", branch: "master"

  depends_on "rust" => :build
  uses_from_macos "expect" => :test

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--features", "lyric-finder,image", *std_cargo_args(path: "spotify_player")
    bin.install "target/release/spotify_player"
  end

  test do
    (testpath/"command.exp").write <<~EOS
      spawn #{bin}/spotify_player -C #{testpath}/cache -c #{testpath}/config
      expect {
        "Username:" { send "username\n" }
        default { exit 1 }
      }
      expect {
        "Password for username:" { send "password\n" }
        default { exit 1 }
      }
      expect {
        "Failed to authenticate" { exit 0 }
        default { exit 1 }
      }
      exit 1
    EOS

    system "expect", "-f", "command.exp"

    assert_match version.to_s, shell_output("#{bin}/spotify_player --version")
  end
end
