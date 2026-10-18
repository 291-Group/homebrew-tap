class LanOrangutan < Formula
  desc "Network discovery and device tracking tool"
  homepage "https://github.com/291-Group/LAN-Orangutan"
  version "3.4.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/291-Group/LAN-Orangutan/releases/download/v3.4.2/orangutan-darwin-arm64.tar.gz"
      sha256 "7fe673f97a50af3da350b818c1f6f992d412c01fcb8844add3a5ccd75b35970d"
    else
      url "https://github.com/291-Group/LAN-Orangutan/releases/download/v3.4.2/orangutan-darwin-amd64.tar.gz"
      sha256 "2b5395d7738622fa1e6190d021fe91743fc25e7f0b4adaab1aa0348ccd4d8443"
    end
  end

  depends_on "nmap"

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
