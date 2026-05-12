class ZzDrop < Formula
  desc "CLI and local agent for zz-drop"
  homepage "https://zz-drop.net"
  version "0.0.1-pre.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.3/zz-drop-aarch64-apple-darwin.tar.xz"
      sha256 "5b2657db3525163dace233624e7368f20c206d35323d2979bd90101e93804f36"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.3/zz-drop-x86_64-apple-darwin.tar.xz"
      sha256 "b621b52002c5530656c41ee771e71c44f0b5549f486fe2ed584bb73d13598f5d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.3/zz-drop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9875700d03ac1c8d5123d170c7d81c7fa299f79d74eced0624ce2392ccee7511"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.3/zz-drop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "632bfc40e8a2bf91ed24ad3e21bd9daab6c11d1b0ac2509d73dd6050291029dc"
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
