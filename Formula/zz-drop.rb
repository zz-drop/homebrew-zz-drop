class ZzDrop < Formula
  desc "CLI and local agent for zz-drop"
  homepage "https://zz-drop.net"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.9.0/zz-drop-aarch64-apple-darwin.tar.xz"
      sha256 "03beea64f3e90ed6edf957b1081fec19b628c3e6253914a25fa39b62c145033f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.9.0/zz-drop-x86_64-apple-darwin.tar.xz"
      sha256 "4cab6996bd19be2a2c8fcb7067c8977c6f3c735e25c59f72aff075076dafbdd4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.9.0/zz-drop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cfcfb9236db94d3bb84df324110dce7670b1d160bc4814a7c6a69e90101edfc7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.9.0/zz-drop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8425ac578ac60318c5eb25f98197bb3032d1e78acd50fcec9e38ce8e97b33701"
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

    generate_completions_from_executable(bin/"zz-drop", "--completions", shells: [:bash, :zsh, :fish])

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
