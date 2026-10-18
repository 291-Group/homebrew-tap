class LanOrangutan < Formula
  desc "Network discovery and device tracking tool"
  homepage "https://github.com/291-Group/LAN-Orangutan"
  version "3.4.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/291-Group/LAN-Orangutan/releases/download/v3.4.2/orangutan-darwin-arm64.tar.gz"
      sha256 "924339abd4b87e3b9af84db52d25fc6ced8f835cb252c375615f976d8076abf4"
    else
      url "https://github.com/291-Group/LAN-Orangutan/releases/download/v3.4.2/orangutan-darwin-amd64.tar.gz"
      sha256 "a4a58ac8e98b98abeee40bee24d327ba5f29a2e29002bfc67fc99ba867860777"
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
