class ZzDropTui < Formula
  desc "Ratatui-based setup and configuration UI for zz-drop"
  homepage "https://zz-drop.net"
  version "0.0.1-pre.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.3/zz-drop-tui-aarch64-apple-darwin.tar.xz"
      sha256 "c62e6bb4d30b389e3039da7b2ae8ff8da026ad7dc8378b065e0a71a40c179554"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.3/zz-drop-tui-x86_64-apple-darwin.tar.xz"
      sha256 "50935855d7ae83c69a6d6dedfabeae83ab92fbed9fcf899646522d26a8ba342d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.3/zz-drop-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "baabfcc00570687c2a540aef0d3862675739266e86d024c7216da300246f71eb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.3/zz-drop-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bfb29e1d25eb828b872859bcfef25aed8bad6a4fdf5db160d0a25d041acf788a"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "zz-tui" if OS.mac? && Hardware::CPU.arm?
    bin.install "zz-tui" if OS.mac? && Hardware::CPU.intel?
    bin.install "zz-tui" if OS.linux? && Hardware::CPU.arm?
    bin.install "zz-tui" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
