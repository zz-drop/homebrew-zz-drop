class ZzDrop < Formula
  desc "CLI and local agent for zz-drop"
  homepage "https://zz-drop.net"
  version "0.0.1-pre.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.5/zz-drop-aarch64-apple-darwin.tar.xz"
      sha256 "0e5747d5bb5a1c915615fb2a7ed3a57c38946d4df610a4e29ebee6fe32b3240f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.5/zz-drop-x86_64-apple-darwin.tar.xz"
      sha256 "06f463977db309a265595280ea60ae1d2e4ff92312647f5c600bdac8e0abc890"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.5/zz-drop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a38dfdf1f733a557b62639ad44fe6648cfa35319643c8c6f3d639fd657bca1a9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.5/zz-drop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "85530ed05411726ad264d134e37be543aeecd2eeeb96eef26880f2865b8ef62c"
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
  def post_install
    zz = HOMEBREW_PREFIX/"bin/zz"
    zz.make_symlink opt_bin/"zz-drop" unless zz.exist?
  end
end
