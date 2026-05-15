class ZzDrop < Formula
  desc "CLI and local agent for zz-drop"
  homepage "https://zz-drop.net"
  version "0.0.1-pre.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.9/zz-drop-aarch64-apple-darwin.tar.xz"
      sha256 "af2cd5731c50e92e1435e040ab59b1543f7b5ae1403b70e9c0aa0f6d500cb668"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.9/zz-drop-x86_64-apple-darwin.tar.xz"
      sha256 "d663286b77aaf947f68c0f27d659ae122a9edf74533cab8e57195a0db66dd68b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.9/zz-drop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ca2953fadce93c0107be3f0be138a0c127a2771cb38903af93f6f2ca961410ca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.0.1-pre.9/zz-drop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ac982766a3250af96bff458e206c9c7e9eb265fdc5abed87bd6174bc774f9e98"
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
