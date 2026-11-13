# Homebrew formula for the `darpan` CLI.
#
# Install:  brew tap drpn-ai/tap && brew trust --formula drpn-ai/tap/darpan && brew install darpan
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
  url "https://github.com/drpn-ai/darpan-cli/releases/download/v0.2.3/darpan-0.2.3.tar.gz"
  sha256 "dbaf69850215c4c70f1958b5ab7e9eadb3e82e68c12f21e144b5f728c501051f"
  license "Apache-2.0"
  # version is inferred from the url (darpan-0.2.3.tar.gz)

  # No depends_on: a Homebrew dependency is upgraded on every install (node and
  # its libraries) and compiled from source on Macs Homebrew has no bottle for.
  # The launcher checks for Node 22.18+ before any data command, and `darpan
  # doctor` / `darpan up` check the local stack's JDK 21, Node and git.

  def install
    libexec.install "bin", "agent"
    # bin/darpan finds ../agent next to itself (it follows symlinks), so link, do not copy.
    bin.install_symlink libexec/"bin/darpan"
  end

  def caveats
    <<~EOS
      Use Darpan from a terminal or Claude Code. It needs Node 22.18 or newer;
      if `node --version` shows none or an older one, install it from https://nodejs.org

        darpan login    # a page opens: type the code your terminal shows
        darpan guide    # the usual path, limits and roles

      Add it to Claude Code as an MCP server:

        claude mcp add darpan -- darpan mcp

      The CLI must be turned on for you in each tenant; ask in Darpan under
      User settings > CLI sessions. Setup guide:
      https://docs.drpn.ai/getting-started/set-up-darpan-cli

      To run a local Darpan stack instead (Moqui 4 / Spark 4), add JDK 21 first:

        brew install --cask temurin@21
        darpan doctor   # verify prerequisites (JDK 21, git, ports)
        darpan up       # clone, load, and run the stack (first run takes a while)
    EOS
  end

  test do
    assert_match "darpan #{version}", shell_output("#{bin}/darpan version")
    assert_match "Usage:", shell_output("#{bin}/darpan help 2>&1")
    assert_match "darpan login", shell_output("#{bin}/darpan help 2>&1")
  end
end
