# Libraries and tools in MATLAB's FHS environment, for `buildFHSEnv`'s
# `targetPkgs`: the dependency list of the release (deps/<release>.nix, made
# by deps/update-deps.py from MathWorks' own lists), and the packages below,
# which every release gets.
{ lib, release }:

pkgs:

let
  file = ./deps + "/${lib.toLower release}.nix";
  supported = map (name: "R" + lib.removePrefix "r" (lib.removeSuffix ".nix" name)) (
    lib.filter (lib.hasPrefix "r20") (lib.attrNames (builtins.readDir ./deps))
  );
in
if !builtins.pathExists file then
  throw ''
    matlab: no dependency list for MATLAB ${release} (deps/ has ${lib.concatStringsSep ", " supported}).
    Make one with `nix run .#update-deps -- ${release}`.''
else
  import file pkgs
  ++ (with pkgs; [
    # Not packages in MathWorks' lists, because a Debian system always has
    # them.
    # In the lists of earlier releases, but not in the R2026b list. The
    # R2026b environment was tested with them, so they stay.
    # mex compiles with the system gcc.
    alsa-lib # libasound2
    at-spi2-atk
    at-spi2-core
    atk
    bashInteractive
    cacert
    cairo
    clang-tools
    coreutils
    cups
    dbus
    fontconfig
    fontconfig.lib
    freetype
    gbenchmark
    gcc
    gcc15.cc.lib
    gdk-pixbuf
    gdk-pixbuf.out
    gfortran
    glamoroustoolkit.out
    glib
    glib.out
    glibc
    glibcLocales
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    gtk2
    gtk2-x11
    gtk3
    jre
    libGL
    libGL.out
    libGLU.out
    libSM.out
    libdrm
    libgbm
    libgcc.lib
    libglvnd
    libjpeg8.out
    libjpeg_turbo
    libpng.out
    libselinux
    libsm
    libsndfile
    libtiff
    libuuid
    libx11
    libx11.out
    libxcb
    libxcomposite
    libxcrypt
    libxcrypt-legacy
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxft
    libxi
    libxinerama
    libxkbcommon
    libxkbcommon.out
    libxrandr
    libxrender
    libxt
    libxtst
    libxxf86vm
    linux-pam
    llvmPackages.clang
    llvmPackages.openmp
    mesa
    motif
    mpi.out
    ncurses
    nspr
    nss
    openblas
    pam
    pango
    pango.out
    procps
    python3
    udev
    unzip
    which
    xkeyboard_config
    zlib
  ])
