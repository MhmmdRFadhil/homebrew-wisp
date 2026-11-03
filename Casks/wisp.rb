cask "wisp" do
  version "1.0.0"
  sha256 "95e4a04893078c913002a94ae9b3d1b3af53409e39e8ca2ccc816c8d15ace3b0"

  url "https://github.com/MhmmdRFadhil/wisp-releases/releases/download/v#{version}/Wisp-#{version}.dmg",
      verified: "github.com/MhmmdRFadhil/wisp-releases/"
  name "Wisp"
  desc "Notch app for macOS with a firefly inside"
  homepage "https://wispnotch.vercel.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # No `auto_updates true`: Wisp has no updater of its own yet, so `brew upgrade` is how it gets new versions.
  depends_on macos: ">= :sonoma"

  app "Wisp.app"

  # Wisp is signed with the maker's own certificate, not notarized (no paid Apple account yet). Homebrew marks every
  # download as "from the internet", which would make macOS block each new version again; clearing that mark on
  # Wisp.app alone, at install, keeps installs and upgrades opening normally. Remove this once Wisp is notarized.
  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/Wisp.app"]
  end

  zap trash: [
    "~/Library/Application Support/Wisp",
    "~/Library/Caches/dev.wisp.app",
    "~/Library/HTTPStorages/dev.wisp.app",
    "~/Library/Preferences/dev.wisp.app.plist",
  ]

  caveats <<~EOS
    Wisp is not notarized by Apple yet. If macOS still says it cannot be opened:
      open System Settings > Privacy & Security, scroll down and press "Open Anyway".
  EOS
end
