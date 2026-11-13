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
  url "https://github.com/drpn-ai/darpan-cli/releases/download/v0.2.1/darpan-0.2.1.tar.gz"
  sha256 "ab16fb4e4282ff2396be9888c8ccb329a78261c7645594031f8aba0df0e28b1a"
  license "Apache-2.0"
  # version is inferred from the url (darpan-0.2.1.tar.gz)

  # The CLI (login, data commands, MCP) needs only Node. The local stack's JDK 21
  # and git are checked by `darpan doctor` / `darpan up` when they run, so users
  # who only sign in to a hosted Darpan do not install a JDK and its font stack.
  depends_on "node"

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
