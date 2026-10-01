class SshAskpassUi < Formula
  desc "Native macOS dialogs for FIDO2/SK touch and ssh-agent key confirmation"
  homepage "https://github.com/sektioneins/ssh-askpass-ui"
  url "https://github.com/sektioneins/ssh-askpass-ui/archive/801b4bc165c53140120b7a7823a7e5acc11e3a1e.tar.gz"
  version "0.0.1"
  sha256 "c7e6a76cd3819d0ea90d8a03b6b08bfcc96b14f549ac886607f7e5b0be73bccf"
  license "Apache-2.0"

  depends_on :macos

  def install
    # install.sh expects the askpass program and the plist template next to
    # itself, so keep the three files together.
    libexec.install "install.sh", "ssh-askpass-ui", "de.sektioneins.ssh-agent-ui.plist"
  end

  def caveats
    <<~EOS
      To install the askpass and its private ssh-agent for your user, run
      install.sh through the stable opt/ path, so that `brew upgrade` keeps
      the ~/bin/ssh-askpass-ui link current:

        #{opt_libexec}/install.sh

      This links ~/bin/ssh-askpass-ui to #{opt_libexec}/ssh-askpass-ui,
      installs ~/Library/LaunchAgents/de.sektioneins.ssh-agent-ui.plist and
      loads the agent on ~/.ssh/agent-ui.sock. Use `--copy` instead for a
      standalone copy that does not follow upgrades. Re-run it after an
      upgrade that changes the plist template.

      Then point ssh at the private agent:
        ~/.zshrc:       export SSH_AUTH_SOCK="$HOME/.ssh/agent-ui.sock"
        ~/.ssh/config:  Host *
                            IdentityAgent ~/.ssh/agent-ui.sock

      Load keys with per-use confirmation:
        ssh-add -c ~/.ssh/id_ed25519

      To remove the agent and the ~/bin link again (do this before
      `brew uninstall`):
        #{opt_libexec}/install.sh --uninstall

      See #{homepage} for details.
    EOS
  end

  test do
    system "sh", "-n", libexec/"install.sh"
    system "plutil", "-lint", libexec/"de.sektioneins.ssh-agent-ui.plist"
    assert_predicate libexec/"ssh-askpass-ui", :executable?
  end
end
