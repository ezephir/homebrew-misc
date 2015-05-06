# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /Volumes/DataHD/Tools/Homebrew/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class MltonBootstrap < Formula
  homepage "http://www.mlton.org"
  url "https://downloads.sourceforge.net/project/mlton/mlton/20130715/mlton-20130715-1.amd64-darwin.gmp-static.tgz"
  version "20130715"
  sha256 "7c7a660515b44e97993e2330297e1454bb5d5fc01d802ae5579611fe4d9b8de7"
  
  
  # depends_on "cmake" => :build
  # depends_on "gmp" # if your formula requires any X11/XQuartz components
  
  patch :DATA
  keg_only "This package is only useful for installing mlton from source."

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    prefix.install 'local/bin'
    prefix.install 'local/lib'
    prefix.install 'local/man'
    prefix.install 'local/share'
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test mlton`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end

__END__
diff --git a/local/bin/mlton b/local/bin/mlton
index f60a7b2..05b5df6 100755
--- a/local/bin/mlton
+++ b/local/bin/mlton
@@ -5,7 +5,7 @@
 set -e
 
 dir=`dirname "$0"`
-lib='/usr/local/lib/mlton'
+lib="$dir/../lib/mlton"
 eval `"$lib/platform"`
 gcc='gcc'
 case "$HOST_OS" in
@@ -99,7 +99,8 @@ doit "$lib" \
         -cc-opt-quote "-I$lib/include"                           \
         -cc-opt '-O1 -fno-common'                                \
         -cc-opt '-fno-strict-aliasing -fomit-frame-pointer -w'   \
-        -link-opt '-lm /opt/local/lib/libgmp.a -Wl,-no_pie'      \
+        -cc-opt '-IHOMEBREW_PREFIX/include'                      \
+        -link-opt '-lm HOMEBREW_PREFIX/lib/libgmp.a -Wl,-no_pie' \
         -mlb-path-map "$lib/mlb-path-map"                        \
         -target-as-opt amd64 '-m64'                              \
         -target-as-opt x86 '-m32'                                \
