cask "wisp" do
  version "1.0.1"
  sha256 "f2562b313383748a1488c4efbdec163a3a195ce8c501ddbff64dce6138a5ffd9"

  url "https://github.com/MhmmdRFadhil/wisp-releases/releases/download/v#{version}/Wisp-#{version}.dmg"
  name "Wisp"
  desc "Notch app for macOS with a firefly inside"
  homepage "https://wispnotch.vercel.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # No `auto_updates true`, although Wisp has Sparkle: Homebrew installs keep `brew upgrade` as their way, so Homebrew
  # keeps track of the installed version.
  depends_on macos: :sonoma

  app "Wisp.app"

  # Homebrew 7 form (`postflight_steps`, a declared command instead of a Ruby block, as homebrew/cask's orbstack does).
  # Wisp is signed with the maker's own certificate, not notarized (no paid Apple account yet). Homebrew marks every
  # download as "from the internet", which would make macOS block each new version again; clearing that mark on
  # Wisp.app alone, at install, keeps installs and upgrades opening normally. Remove this once Wisp is notarized.
  postflight_steps do
    # Steps are data, not Ruby: no `appdir` method here, the path is the {{appdir}} template token instead.
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Wisp.app"]
  end

  zap trash: [
    "~/Library/Application Support/Wisp",
    "~/Library/Caches/dev.wisp.app",
    "~/Library/HTTPStorages/dev.wisp.app",
    "~/Library/Preferences/dev.wisp.app.plist",
  ]

  caveats <<~EOS
    Wisp is ready: open it from Applications. Updates come with `brew upgrade --cask wisp`.
    In the rare case macOS says it cannot be opened (Wisp isn't notarized by Apple yet):
      open System Settings > Privacy & Security, scroll down and press "Open Anyway".
  EOS
end
