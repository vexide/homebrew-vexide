class CargoV5 < Formula
  desc "Cargo subcommand for managing V5 Brain Rust projects"
  homepage "https://vexide.dev"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vexide/cargo-v5/releases/download/v0.11.0/cargo-v5-aarch64-apple-darwin.tar.xz"
      sha256 "b4b0e22fc43fefde07d63cc7eca70c99ae2f145363edbe5a8f243bb476d13553"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vexide/cargo-v5/releases/download/v0.11.0/cargo-v5-x86_64-apple-darwin.tar.xz"
      sha256 "85907740a2918781a889cf1faa5a31c761e0c5a67c9c446525a3bf90a144844b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/vexide/cargo-v5/releases/download/v0.11.0/cargo-v5-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "d11cb4609639767e04acb179298d11eed32825b29788baf26e17f9521fcdbb8b"
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
