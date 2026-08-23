cask "lan-sheriff" do
  version "1.0.0"

  on_arm do
    sha256 "417ff3e861a4d52ed3151e29faf3a9587bdc14b722bacd4e722b99b705217f77"
    url "https://github.com/291-Group/LAN-Sheriff/releases/download/v1.0.0/lan-sheriff_1.0.0_darwin_arm64.tar.gz"
  end
  on_intel do
    sha256 "537351b5518ce1cd3aac93a1143f887e55936a4618d128a807b9a90b72ee0f8d"
    url "https://github.com/291-Group/LAN-Sheriff/releases/download/v1.0.0/lan-sheriff_1.0.0_darwin_amd64.tar.gz"
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
