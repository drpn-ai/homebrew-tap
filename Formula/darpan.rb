# Draft Homebrew formula for the `darpan` CLI.
#
# This file is destined for the tap repo at drpn-ai/homebrew-tap as
# `Formula/darpan.rb`. It is kept here during prototyping so it can be
# reviewed alongside the CLI it installs.
#
# Before publishing:
#   1. Cut a release tarball of darpan-cli (see ../README is the CLI README;
#      the release process is documented in DAR-287). The tarball must contain
#      `bin/darpan`.
#   2. Replace the url/sha256 below with the real release asset + checksum:
#        curl -fsSLO <release-tarball-url>
#        shasum -a 256 darpan-<version>.tar.gz
#   3. Commit to drpn-ai/homebrew-tap, then:
#        brew tap drpn-ai/tap
#        brew install darpan
#
# Note: this formula installs only the launcher. `darpan up` does the cloning,
# Gradle build, data load, and process start at runtime — Homebrew formulae
# must not perform network/build work during `brew install`.

class Darpan < Formula
  desc "Bootstrap and run a local Darpan reconciliation development stack"
  homepage "https://github.com/drpn-ai/darpan"
  url "https://github.com/drpn-ai/darpan-cli/releases/download/v0.1.0/darpan-0.1.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "Apache-2.0"
  version "0.1.0"

  depends_on "git"
  depends_on "node"
  depends_on "openjdk@21"

  def install
    bin.install "bin/darpan"
  end

  def caveats
    <<~EOS
      Darpan needs JDK 21 (Moqui 4 / Spark 3.5). This formula depends on
      openjdk@21; the CLI resolves it automatically. To start:

        darpan doctor   # verify prerequisites
        darpan up       # clone, load, and run the stack (first run takes a while)

      The stack runs at:
        UI    http://localhost:5173
        API   http://localhost:8080
    EOS
  end

  test do
    assert_match "darpan #{version}", shell_output("#{bin}/darpan version")
    assert_match "Usage:", shell_output("#{bin}/darpan help 2>&1")
  end
end
