# Homebrew formula for the `darpan` CLI.
#
# Install:  brew tap drpn-ai/tap && brew install darpan
#
# This installs only the launcher. `darpan up` does the cloning, Gradle build,
# data load, and process start at runtime — Homebrew formulae must not perform
# network/build work during `brew install`.
#
# On a new darpan-cli release: the release workflow prints url/sha256/version;
# bump them below and commit. See README for the full flow.

class Darpan < Formula
  desc "Bootstrap and run a local Darpan reconciliation development stack"
  homepage "https://github.com/drpn-ai/darpan"
  url "https://github.com/drpn-ai/darpan-cli/releases/download/v0.1.1/darpan-0.1.1.tar.gz"
  sha256 "094b86669c7e1bec56d817abf796f1a0187850cfce05b3ba935d16aa6c0f15ef"
  license "Apache-2.0"
  # version is inferred from the url (darpan-0.1.1.tar.gz)

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
