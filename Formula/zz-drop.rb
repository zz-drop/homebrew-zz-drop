class ZzDrop < Formula
  desc "CLI and local agent for zz-drop"
  homepage "https://zz-drop.net"
  version "0.9.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.9.6/zz-drop-aarch64-apple-darwin.tar.xz"
      sha256 "df3b5a924196970fe03f587128d4b74b736f9a2ddb788b08eb4ed5aad84c21b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.9.6/zz-drop-x86_64-apple-darwin.tar.xz"
      sha256 "b85ceb163805fb47fc619c4d6d1b83a187785c7e7f01bb6e8fd9d82ca5177ab0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.9.6/zz-drop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "75b4fb754d6a6ff59d9eafa91ea5d39e4cded01174b01bab476554f8168edfae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.9.6/zz-drop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "14812b922d378bc6041934c85dcae45b14d989ec24e3ee6f7975b5d11fd71ee8"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {
      "zz-drop": [
        "zz",
      ],
    },
    "aarch64-unknown-linux-gnu":          {
      "zz-drop": [
        "zz",
      ],
    },
    "aarch64-unknown-linux-musl-dynamic": {
      "zz-drop": [
        "zz",
      ],
    },
    "aarch64-unknown-linux-musl-static":  {
      "zz-drop": [
        "zz",
      ],
    },
    "x86_64-apple-darwin":                {
      "zz-drop": [
        "zz",
      ],
    },
    "x86_64-unknown-linux-gnu":           {
      "zz-drop": [
        "zz",
      ],
    },
    "x86_64-unknown-linux-musl-dynamic":  {
      "zz-drop": [
        "zz",
      ],
    },
    "x86_64-unknown-linux-musl-static":   {
      "zz-drop": [
        "zz",
      ],
    },
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
    bin.install "zz-drop", "zz-tui" if OS.mac? && Hardware::CPU.arm?
    bin.install "zz-drop", "zz-tui" if OS.mac? && Hardware::CPU.intel?
    bin.install "zz-drop", "zz-tui" if OS.linux? && Hardware::CPU.arm?
    bin.install "zz-drop", "zz-tui" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
