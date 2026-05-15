class ZzDrop < Formula
  desc "CLI and local agent for zz-drop"
  homepage "https://zz-drop.net"
  version "0.0.1-pre.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.8/zz-drop-aarch64-apple-darwin.tar.xz"
      sha256 "41cf6194b6b948cc573b33ba2a64e63b3ef70f9af7263c5c31ba092b814f2626"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.8/zz-drop-x86_64-apple-darwin.tar.xz"
      sha256 "5b90a28dd0941a8f9b79ef0984fac9e5fbc62ff80339050892aa1c6ef6d07b78"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.8/zz-drop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "61cce12009c14130ace23836c9d3bab48267577f4e9f41c5adc4cfa878d79432"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.8/zz-drop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4f8fe91b4e0c5275215ed904f43ab5ba99280f46dfecebe2f25fda5feab63b23"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
