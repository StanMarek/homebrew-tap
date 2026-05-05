class GhostComplete < Formula
  desc "Terminal-native autocomplete engine using PTY proxying for macOS terminals"
  homepage "https://github.com/StanMarek/ghost-complete"
  version "0.12.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/StanMarek/ghost-complete/releases/download/v0.12.3/ghost-complete-aarch64-apple-darwin.tar.xz"
      sha256 "3c517c25bc08b8f955079aa495fc9f4c8fa295b28977e84d9423df19dc2cc430"
    end
    if Hardware::CPU.intel?
      url "https://github.com/StanMarek/ghost-complete/releases/download/v0.12.3/ghost-complete-x86_64-apple-darwin.tar.xz"
      sha256 "de0095a9cdbe9888705544be562fcda1d54936e76ef56c1247581c7e91b92b1a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
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
    bin.install "ghost-complete" if OS.mac? && Hardware::CPU.arm?
    bin.install "ghost-complete" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
