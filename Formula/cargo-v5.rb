class CargoV5 < Formula
  desc "Cargo tool for working with VEX V5 Rust projects."
  homepage "https://vexide.dev"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vexide/cargo-v5/releases/download/v0.12.0/cargo-v5-aarch64-apple-darwin.tar.xz"
      sha256 "e499d401fc3e0edbdf8080fe813c227be877ab31d3ce4cbe663b2bb471d4edd2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vexide/cargo-v5/releases/download/v0.12.0/cargo-v5-x86_64-apple-darwin.tar.xz"
      sha256 "c206994231d2d2eb8add65acd687621483e8919d5c47734bb5fb68f80939ef0a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/vexide/cargo-v5/releases/download/v0.12.0/cargo-v5-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "015e29cbadffddf163fdc24b596ca733a1d48a0ce264e6211c570748928c0f71"
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
