# A collection of containers

This repo is intended as a collection of tools for creating
semi-reproducible development environment on non-nix systems

## Stack needed

  - Podman
  - Docker (possibly rootless) [note that can be avoided using podman with some thinkering]
  - Devcontainers/CLI (it needs Node.js)

## Why should I use it?

I recently switched from NixOS to Fedora Atomic for my main pcs. Even though Nix is way more useful
in terms of reproducibility, overall the immutable implementation of fedora is way more user friendly for me.

One thing I really miss from NixOS is the ability of creating reproducible and ephemeral environments.
This issue can be mitigated using containers, of course.

Following the mindset of uBlue OS (kudos to Jorge Castro and friends) I like to keep my system as pure and clean as possible, so all the dev stuff is put on some sort
of containerized environment.

This repo is used as a place to store my custom config for devcontainers and - eventually - little podman containers for compiling stuff.

### Can I contribute?

If you follow a similar development workflow or linux desktop usage, feel free to contribute to this archive. 
