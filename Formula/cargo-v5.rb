class CargoV5 < Formula
  desc "A cargo subcommand for managing V5 Brain Rust projects"
  homepage "https://vexide.dev"
  version "0.11.0-alpha.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vexide/cargo-pros/releases/download/v0.11.0-alpha.1/cargo-v5-aarch64-apple-darwin.tar.xz"
      sha256 "bb58a72a424fbf447db1c76a108859aba8939bf3f22c549e44e74bf3de326f7e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vexide/cargo-pros/releases/download/v0.11.0-alpha.1/cargo-v5-x86_64-apple-darwin.tar.xz"
      sha256 "3fbbf476e485dc7a6fc62c556e78aa8b198cca2cdeb446246061a5438a4180ab"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/vexide/cargo-pros/releases/download/v0.11.0-alpha.1/cargo-v5-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "1e7ae919e66b3383f78f9c9d8101cdac63b30cf69fff7b6dd352d7e381deaf36"
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
