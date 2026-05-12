class ZzDropTui < Formula
  desc "Ratatui-based setup and configuration UI for zz-drop"
  homepage "https://zz-drop.net"
  version "0.0.1-pre.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.4/zz-drop-tui-aarch64-apple-darwin.tar.xz"
      sha256 "ec32aaaa77ad072f3f75386f48603aff59d663842626ff550227dbeab813d045"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.4/zz-drop-tui-x86_64-apple-darwin.tar.xz"
      sha256 "b8490953055c3b4de0f33c9dd50ff53dbfb844e9e69251ba181a3efb6d106848"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.4/zz-drop-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "25defe5e9679df90a9e7de31a6ee40c268b1f504c1f7c9af8a53325906af704d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.4/zz-drop-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0264633b60d7c7ab01bac97a2c91049b67e7f4fe9b3089efdfec6ca0a32f1660"
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
