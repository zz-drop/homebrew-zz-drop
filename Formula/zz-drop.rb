class ZzDrop < Formula
  desc "CLI and local agent for zz-drop"
  homepage "https://zz-drop.net"
  version "0.9.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.9.5/zz-drop-aarch64-apple-darwin.tar.xz"
      sha256 "62307eb51cd03f5a7702fb57ff6588f26334d887fe61dda20e9e08ad70ffe61d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.9.5/zz-drop-x86_64-apple-darwin.tar.xz"
      sha256 "193d6b7fcd5e18ed08fbdebd92f9800bdbbb929c14660c98ddd9fb46175eaa52"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.9.5/zz-drop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "46380575a94fff5d264f7b44004d4faa51989f045b9efbe2129cf58ab3c054f1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.9.5/zz-drop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c126474bd05629200e56e963c5b8e5dcb8889bc2b838f39dbca8462da8ad128e"
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
