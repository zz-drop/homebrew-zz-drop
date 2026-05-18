class ZzDrop < Formula
  desc "CLI and local agent for zz-drop"
  homepage "https://zz-drop.net"
  version "0.9.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.9.3/zz-drop-aarch64-apple-darwin.tar.xz"
      sha256 "558d37c8588f21675b861c9d922e18fe97b24eb2c0f84d78ab2d0de08cf5da62"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.9.3/zz-drop-x86_64-apple-darwin.tar.xz"
      sha256 "19a0b374c7f71ded37aee8a0c2b56b45e0357b3868e7cf04bb0449da743c10a8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.9.3/zz-drop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d79d87f7a2f82438952c95f0fc07ddeedbddcbd974afa09ee4554d7d51f36c0c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.9.3/zz-drop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "701fded1738bf0ac5b9fb2ff04887d9acb935893edb5c5d75e35ca5c230d83e7"
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
