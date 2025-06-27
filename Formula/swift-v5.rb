class SwiftV5 < Formula
  desc "Create VEX V5 programs in Swift"
  homepage "https://github.com/vexide/swift-v5"
  version "0.1.0-rc.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vexide/swift-v5/releases/download/v0.1.0-rc.4/swift-v5-aarch64-apple-darwin.tar.xz"
      sha256 "029a20fbdc9ed42340e27016ac1a4b91c2a3c57fa0c0eb4b73c92f03cb610d21"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vexide/swift-v5/releases/download/v0.1.0-rc.4/swift-v5-x86_64-apple-darwin.tar.xz"
      sha256 "37b2cbb642b130ef7af154ee78d1e61c5d7fe5c3c7a139a2a888a09335908ba7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vexide/swift-v5/releases/download/v0.1.0-rc.4/swift-v5-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "28ab4e47b27693d195a1620b41a4e6196443b533b02819a282dcc530e1d6e215"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vexide/swift-v5/releases/download/v0.1.0-rc.4/swift-v5-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2b48f5fda62dafdde36e6f7e47d7a6e15eb2062694e91ff47352153968782ffa"
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
