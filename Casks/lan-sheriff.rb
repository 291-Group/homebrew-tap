cask "lan-sheriff" do
  version "1.0.3"

  on_arm do
    sha256 "b40d91e4f480139b47f4ee02b9dc3bbe4aefa2a8864f736d4d5aea77c2f1f1f9"
    url "https://github.com/291-Group/LAN-Sheriff/releases/download/v1.0.3/lan-sheriff_1.0.3_darwin_arm64.tar.gz"
  end
  on_intel do
    sha256 "260e39a8ac76b5417dddf27b922276fb636fc183be57ce463c536c63de747a87"
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
