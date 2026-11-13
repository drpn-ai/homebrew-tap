# Homebrew formula for the `darpan` CLI.
#
# Install:  brew tap drpn-ai/tap && brew install darpan
#
# This installs the launcher (bin/darpan) and the Node CLI it hands data and
# action commands to (agent/). `darpan up` does the cloning, Gradle build, data
# load, and process start at runtime — Homebrew formulae must not perform
# network/build work during `brew install`.
#
# On a new darpan-cli release: the release workflow prints url/sha256;
# bump them below and commit. See the darpan-cli README for the full flow.

class Darpan < Formula
  desc "Use Darpan from your terminal or Claude Code, or run a local Darpan stack"
  homepage "https://github.com/drpn-ai/darpan-cli"
  url "https://github.com/drpn-ai/darpan-cli/releases/download/v0.2.0/darpan-0.2.0.tar.gz"
  sha256 "678e73d588c45595c214d22798229edceed9a10b931d3c7b881b5abaecb9bcaf"
  license "Apache-2.0"
  # version is inferred from the url (darpan-0.2.0.tar.gz)

  depends_on "git"
  depends_on "node"
  depends_on "openjdk@21"

  def install
    libexec.install "bin", "agent"
    # bin/darpan finds ../agent next to itself (it follows symlinks), so link, do not copy.
    bin.install_symlink libexec/"bin/darpan"
  end

  def caveats
    <<~EOS
      Use Darpan from a terminal or Claude Code (Node 22.18+, installed with this formula):

        darpan login    # a page opens: type the code your terminal shows
        darpan guide    # the usual path, limits and roles

      Add it to Claude Code as an MCP server:

        claude mcp add darpan -- darpan mcp

      The CLI must be turned on for you in each tenant; ask in Darpan under
      User settings > CLI sessions. Setup guide:
      https://docs.drpn.ai/getting-started/set-up-darpan-cli

      To run a local Darpan stack instead (JDK 21, Moqui 4 / Spark 4):

        darpan doctor   # verify prerequisites
        darpan up       # clone, load, and run the stack (first run takes a while)
    EOS
  end

  test do
    assert_match "darpan #{version}", shell_output("#{bin}/darpan version")
    assert_match "Usage:", shell_output("#{bin}/darpan help 2>&1")
    assert_match "darpan login", shell_output("#{bin}/darpan help 2>&1")
  end
end
