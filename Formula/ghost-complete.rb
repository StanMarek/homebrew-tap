class GhostComplete < Formula
  desc "Terminal-native autocomplete engine using PTY proxying for macOS terminals"
  homepage "https://github.com/StanMarek/ghost-complete"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/StanMarek/ghost-complete/releases/download/v0.7.1/ghost-complete-aarch64-apple-darwin.tar.xz"
      sha256 "74ad78c0857f66f3385b3caa362b65e0de2a0f3ac66921e257946c76767ff045"
    end
    if Hardware::CPU.intel?
      url "https://github.com/StanMarek/ghost-complete/releases/download/v0.7.1/ghost-complete-x86_64-apple-darwin.tar.xz"
      sha256 "4b3f3749edde88e9ba83fc4aa90930e5b576518de37927db43670487357c107e"
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
