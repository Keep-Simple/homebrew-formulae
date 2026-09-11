cask "dmenu-mac" do
  version "0.7.2"
  sha256 "db82a9ac07e1fca23e31db2e458979d12fce846a8948e5a053fd8d317967e469"

  url "https://github.com/oNaiPs/dmenu-mac/releases/download/#{version}/dmenu-mac.zip"
  name "dmenu-mac"
  desc "Keyboard-only application launcher"
  homepage "https://github.com/oNaiPs/dmenu-mac"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "dmenu-mac.app"
  # No binary stanza on purpose. Upstream ships Contents/Resources/dmenu-mac, a
  # launcher script that resolves the bundle path with `python -c ...`; macOS 12.3
  # removed Python 2, so it dies with "python: command not found". Symlinking
  # Contents/MacOS/dmenu-mac instead is worse: the process starts, but resolves its
  # bundle relative to the symlink, never loads Main.storyboard, and shows no window.
  # Upstream is unmaintained (0.7.2, 2021). Launch the app with `open` instead.

  zap trash: [
    "~/Library/Application Scripts/com.onaips.dmenu-macos",
    "~/Library/Containers/com.onaips.dmenu-macos",
  ]
end
