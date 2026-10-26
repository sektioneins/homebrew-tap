class MacCleanup < Formula
  desc "Terminal UI that finds reclaimable disk space on a Mac"
  homepage "https://github.com/sektioneins/mac-cleanup"
  url "https://github.com/sektioneins/mac-cleanup/archive/refs/tags/v1.tar.gz"
  sha256 "ebc56ee3c30dd9b65a79c294fa6d057d919d595f232c978cec932189f5bf7870"
  license "Apache-2.0"

  depends_on "go" => :build
  depends_on :macos

  def install
    # The binary looks for its target scripts in scripts/ next to the resolved
    # executable, so keep both in libexec and link the binary under a name that
    # does not clash with mac-cleanup-py and mac-cleanup-go.
    system "go", "build", *std_go_args(ldflags: "-s -w", output: libexec/"mac-cleanup")
    rm Dir["scripts/*_test.go"]
    libexec.install "scripts"
    bin.install_symlink libexec/"mac-cleanup" => "mac-cleanup-s1"
  end

  def caveats
    <<~EOS
      The command is installed as mac-cleanup-s1 to avoid clashing with other
      formulae that provide a mac-cleanup binary.
    EOS
  end

  test do
    (testpath/"scripts/targets/demo.sh").write <<~SH
      #!/bin/bash
      printf 'item\\nid\\tdemo\\nname\\tDemo\\ncategory\\tDeveloper\\npath\\t/tmp/demo\\n'
      printf 'size\\t2097152\\nadmin\\t0\\ncmd_trash\\t/usr/bin/trash /tmp/demo\\n'
      printf 'grade\\tregenerates\\ndefault\\ttrash\\nexplain\\tDemo item.\\nend\\n'
    SH
    assert_match "Demo", shell_output("#{bin}/mac-cleanup-s1 -list -scripts #{testpath}/scripts")

    Dir[libexec/"scripts/**/*.sh"].each { |f| system "/bin/bash", "-n", f }
    assert_path_exists libexec/"scripts/targets/gradle-caches.sh"
  end
end
