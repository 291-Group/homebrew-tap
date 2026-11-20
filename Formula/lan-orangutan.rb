class LanOrangutan < Formula
  desc "Network discovery and device tracking tool"
  homepage "https://github.com/291-Group/LAN-Orangutan"
  license "MIT"

  depends_on "nmap"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/291-Group/LAN-Orangutan/releases/download/v4.0.0/orangutan-darwin-arm64.tar.gz"
      sha256 "ca8425ef61788e8bfe6dc804bbc35c48ee11dffdb5541a0c64fe3438f4c02f69"
    else
      url "https://github.com/291-Group/LAN-Orangutan/releases/download/v4.0.0/orangutan-darwin-amd64.tar.gz"
      sha256 "3589e131682b4273c3d85303459b40f36eb5c1117bb0d9ea2581e4c510578210"
    end
  end

  def install
    bin.install "orangutan-darwin-arm64" => "orangutan" if Hardware::CPU.arm?
    bin.install "orangutan-darwin-amd64" => "orangutan" unless Hardware::CPU.arm?

    # Create config directory
    (etc/"lan-orangutan").mkpath
    (var/"lib/lan-orangutan").mkpath
  end

  service do
    run [opt_bin/"orangutan", "serve"]
    keep_alive true
    working_dir var/"lib/lan-orangutan"
    log_path var/"log/lan-orangutan.log"
    error_log_path var/"log/lan-orangutan.log"
  end

  test do
    system "#{bin}/orangutan", "version"
  end
end
