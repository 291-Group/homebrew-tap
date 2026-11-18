cask "lan-sheriff" do
  version "1.0.3"

  on_arm do
    sha256 "c0a1c2c8915a9454fd4b2ccab1bb6424b0d2a3f0c580bec2aa44bf8df42cc8ae"
    url "https://github.com/291-Group/LAN-Sheriff/releases/download/v1.0.3/lan-sheriff_1.0.3_darwin_arm64.tar.gz"
  end
  on_intel do
    sha256 "be5484f4e64c057a02422efce4ea9a719138c53c9222b7aa1c3f4cffdcc22692"
    url "https://github.com/291-Group/LAN-Sheriff/releases/download/v1.0.3/lan-sheriff_1.0.3_darwin_amd64.tar.gz"
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
