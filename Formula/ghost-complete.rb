class GhostComplete < Formula
  desc "Terminal-native autocomplete engine using PTY proxying for macOS terminals"
  homepage "https://github.com/StanMarek/ghost-complete"
  version "0.14.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/StanMarek/ghost-complete/releases/download/v0.14.0/ghost-complete-aarch64-apple-darwin.tar.xz"
      sha256 "4b4f1f95604450c2cb5e2595f69be5f223e03af8073e372fa0bf34098148fb14"
    end
    if Hardware::CPU.intel?
      url "https://github.com/StanMarek/ghost-complete/releases/download/v0.14.0/ghost-complete-x86_64-apple-darwin.tar.xz"
      sha256 "302314e812a97de2110b429e5016b42a5ec0e0a7bc23733dafcd513b4fab9504"
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
