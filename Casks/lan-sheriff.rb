cask "lan-sheriff" do
  version "1.0.2"

  on_arm do
    sha256 "d0078a4b7fa07a1166ca52b71b71139a24980f9339eabc5fb4f884c2faf35ad6"
    url "https://github.com/291-Group/LAN-Sheriff/releases/download/v1.0.2/lan-sheriff_1.0.2_darwin_arm64.tar.gz"
  end
  on_intel do
    sha256 "30bf3841b2496ef28fc60ed6ff64f54422812ed00908d45969238ff1deffcb05"
    url "https://github.com/291-Group/LAN-Sheriff/releases/download/v1.0.2/lan-sheriff_1.0.2_darwin_amd64.tar.gz"
  end

  name "LAN Sheriff"
  desc "Self-hosted network monitor: watch what leaves, map where it goes, flag what does not belong"
  homepage "https://github.com/291-Group/LAN-Sheriff"

  binary "lan-sheriff"

  postflight do
    # Unsigned, so macOS quarantines it and Gatekeeper reports it as damaged.
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{staged_path}/lan-sheriff"],
                   must_succeed: false
  end

  # Uninstalling leaves the database alone; `brew uninstall --zap` removes it.
  # A monitor that erased months of history because somebody changed how it was
  # installed would be a poor neighbour.
  zap trash: "~/Library/Application Support/lan-sheriff"

  caveats <<~EOS
    Start it with:
      lan-sheriff

    Deputy Mode needs no privileges and works immediately: it names the
    application behind every connection this machine makes.

    Patrol Mode sees other devices and DNS, and needs access to the BPF
    devices, which in practice means:
      sudo lan-sheriff

    Seeing other devices also needs a vantage point. A machine plugged into a
    switch sees its own traffic and broadcast, and nothing else:
      https://github.com/291-Group/LAN-Sheriff/blob/main/docs/VANTAGE-POINTS.md
  EOS
end
