cask "lan-sheriff" do
  version "1.0.1"

  on_arm do
    sha256 "488664bb3af591d0df667166d111f6254beee9fee7039308db0ff282c206c481"
    url "https://github.com/291-Group/LAN-Sheriff/releases/download/v1.0.1/lan-sheriff_1.0.1_darwin_arm64.tar.gz"
  end
  on_intel do
    sha256 "98eee32dbd44293fcd2880e1f7407be45ae7f74eea1d0a116323a51020bcbd35"
    url "https://github.com/291-Group/LAN-Sheriff/releases/download/v1.0.1/lan-sheriff_1.0.1_darwin_amd64.tar.gz"
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
