class LanOrangutan < Formula
  desc "Network discovery and device tracking tool"
  homepage "https://github.com/291-Group/LAN-Orangutan"
  version "4.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/291-Group/LAN-Orangutan/releases/download/v4.0.0/orangutan-darwin-arm64.tar.gz"
      sha256 "af4cebec755e0c9fe7ac7dc634c69acde7a68d6f672d5ebd7b2422c1363f6da4"
    else
      url "https://github.com/291-Group/LAN-Orangutan/releases/download/v4.0.0/orangutan-darwin-amd64.tar.gz"
      sha256 "e9166b5f6aa65ae163d9f41724bfcb9d2220beea6e4c354e2c2c2bc314f6d35b"
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
