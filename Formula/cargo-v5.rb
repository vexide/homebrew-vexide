class CargoV5 < Formula
  desc "Cargo subcommand for managing V5 Brain Rust projects"
  homepage "https://vexide.dev"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vexide/cargo-v5/releases/download/v0.11.0/cargo-v5-aarch64-apple-darwin.tar.xz"
      sha256 "c75da6bdff88a9d3d6fee49d6893cc135d34d2900ff195e91fbd2f70b7b6bdd0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vexide/cargo-v5/releases/download/v0.11.0/cargo-v5-x86_64-apple-darwin.tar.xz"
      sha256 "5ed5cf23748f2d94c407c450336704591cdae7e634328aa1b0479d07aad5ec82"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/vexide/cargo-v5/releases/download/v0.11.0/cargo-v5-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "3d5bb7eb6bf3599cad962624faf2304a34667b276efe1b89789065c2f288a8e5"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "aarch64-pc-windows-gnu":   {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "cargo-v5" if OS.mac? && Hardware::CPU.arm?
    bin.install "cargo-v5" if OS.mac? && Hardware::CPU.intel?
    bin.install "cargo-v5" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
