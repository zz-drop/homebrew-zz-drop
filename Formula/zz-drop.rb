class ZzDrop < Formula
  desc "CLI and local agent for zz-drop"
  homepage "https://zz-drop.net"
  version "0.0.1-pre.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.4/zz-drop-aarch64-apple-darwin.tar.xz"
      sha256 "a4d26be5c963bf8d4240d3210df0b67bc8f81270d0a5227653f689b0860a0e88"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.4/zz-drop-x86_64-apple-darwin.tar.xz"
      sha256 "d5e1f2fde69e445ef5ed9e544a33e53be54aa36bceb489a4d5910ff39407f2a7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.4/zz-drop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6a25e23ba5eab270c9ada1c1fd8a97c4bf2f41af03a0aa695b685178383d52fd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.4/zz-drop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "592d4aebc30b4ca0dddae3ad60f6bce024890688ee3fa6744fcf2892505231bf"
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
    bin.install "zz-drop" if OS.mac? && Hardware::CPU.arm?
    bin.install "zz-drop" if OS.mac? && Hardware::CPU.intel?
    bin.install "zz-drop" if OS.linux? && Hardware::CPU.arm?
    bin.install "zz-drop" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
