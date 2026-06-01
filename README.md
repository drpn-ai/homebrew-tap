# homebrew-tap

Homebrew tap for Darpan tools. Destined for `drpn-ai/homebrew-tap` (the repo name **must** start with `homebrew-` for `brew tap drpn-ai/tap` to resolve).

## Install

```bash
brew tap drpn-ai/tap
brew install darpan
```

Then:

```bash
darpan doctor   # check prerequisites (JDK 21, Node 20+, ports)
darpan up       # clone, load, and run the local stack
```

## Layout

```
homebrew-tap/
  Formula/
    darpan.rb     # formula for the darpan CLI bootstrapper
```

## Updating the formula on a new CLI release

1. Push a `v*` tag in `drpn-ai/darpan-cli`; its `release` workflow builds the tarball, attaches it to a GitHub release, and prints the `url` / `sha256` / `version` in the job summary.
2. Paste those three values into `Formula/darpan.rb` here and commit.
3. Verify locally before publishing:

```bash
brew install --build-from-source ./Formula/darpan.rb
brew test darpan
brew audit --new --formula darpan
```
