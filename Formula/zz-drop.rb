class ZzDrop < Formula
  desc "CLI and local agent for zz-drop"
  homepage "https://zz-drop.net"
  version "0.9.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.9.4/zz-drop-aarch64-apple-darwin.tar.xz"
      sha256 "f27a86c5090a5a75a9375fcb0452d3c10423c3845c80fb0c8586c291b9272498"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.9.4/zz-drop-x86_64-apple-darwin.tar.xz"
      sha256 "e657ee0a824f138db28ba2559c4af3f5201e4bd42289286bf9d9aacea1745bb7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.9.4/zz-drop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d038757b4069f41747c896883ff2851e6264286fa793209aee73cdcac627d42c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zz-drop/zz-drop/releases/download/v0.9.4/zz-drop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3241e366e4ef55f5758fff292c948f5bf4480ce34f636316a5f48ffe590ec586"
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

  def caveats
    <<~EOS
      Shell completions are installed in the cellar. To make them
      load in your shell, two one-line setups (each runs once):

        # 1) put brew's completion dirs on $fpath
        echo 'eval "$(brew shellenv)"' >> ~/.zprofile

        # 2) actually load completions in zsh
        echo 'autoload -Uz compinit && compinit' >> ~/.zshrc

      Open a new terminal, then test with `zz <TAB>`.

      If you'd rather have zz-drop write a delimited block to your
      rc file in one shot (with framework detection for oh-my-zsh,
      prezto, zinit, etc.), run:

        zz --setup-completions

      To check the install at any point: `zz --check-completions`.
    EOS
  end
end
