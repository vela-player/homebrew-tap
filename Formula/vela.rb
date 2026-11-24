# Homebrew formula for vela. The release workflow copies this into the
# vela-player/homebrew-tap repository with the version and sha256 filled in.
class Vela < Formula
  desc "Ultra-fast, ultra-light media player for macOS"
  homepage "https://github.com/vela-player/vela"
  url "https://github.com/vela-player/vela/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "261ad61e34abb76be7df966a1e86e28bd924c44088e1259e473e1c14c3e2c6d8"
  license "GPL-3.0-or-later"
  head "https://github.com/vela-player/vela.git", branch: "main"

  depends_on macos: :ventura
  depends_on "mpv"

  def install
    # Link against mpv's opt path so vela keeps working across mpv upgrades.
    ENV["MPV_PREFIX"] = formula_opt_prefix("mpv")
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/vela"
  end

  def caveats
    <<~EOS
      Play a file:   vela movie.mkv
      Defaults:      ~/.config/vela/config  (one mpv option per line)
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vela --version")
  end
end
