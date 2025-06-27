class SwiftV5 < Formula
  desc "Create VEX V5 programs in Swift"
  homepage "https://github.com/vexide/swift-v5"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vexide/swift-v5/releases/download/v0.1.0/swift-v5-aarch64-apple-darwin.tar.xz"
      sha256 "d65bfdd5c010ccca8da3262f75d0203c36dadf2b1afb0d40b14c48c573c2cf1e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vexide/swift-v5/releases/download/v0.1.0/swift-v5-x86_64-apple-darwin.tar.xz"
      sha256 "e31657bf94d923db72c986eb65a616c0c172bde252c7ad2bbf61dbeba8a5758b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vexide/swift-v5/releases/download/v0.1.0/swift-v5-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c99464735c424a499c5b3c0013114b3c57c389fcf1ef532669c7716eea885b8c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vexide/swift-v5/releases/download/v0.1.0/swift-v5-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f6ed03138e2eebbda55ae917481142765e8302e346806164708119e816395b59"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
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
    bin.install "swift-v5" if OS.mac? && Hardware::CPU.arm?
    bin.install "swift-v5" if OS.mac? && Hardware::CPU.intel?
    bin.install "swift-v5" if OS.linux? && Hardware::CPU.arm?
    bin.install "swift-v5" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
