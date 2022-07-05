# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/Users/jflabonte/.emacs.d/.local/straight/build-28.1/vterm/build/libvterm-prefix/src/libvterm"
  "/Users/jflabonte/.emacs.d/.local/straight/build-28.1/vterm/build/libvterm-prefix/src/libvterm-build"
  "/Users/jflabonte/.emacs.d/.local/straight/build-28.1/vterm/build/libvterm-prefix"
  "/Users/jflabonte/.emacs.d/.local/straight/build-28.1/vterm/build/libvterm-prefix/tmp"
  "/Users/jflabonte/.emacs.d/.local/straight/build-28.1/vterm/build/libvterm-prefix/src/libvterm-stamp"
  "/Users/jflabonte/.emacs.d/.local/straight/build-28.1/vterm/build/libvterm-prefix/src"
  "/Users/jflabonte/.emacs.d/.local/straight/build-28.1/vterm/build/libvterm-prefix/src/libvterm-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/Users/jflabonte/.emacs.d/.local/straight/build-28.1/vterm/build/libvterm-prefix/src/libvterm-stamp/${subDir}")
endforeach()
