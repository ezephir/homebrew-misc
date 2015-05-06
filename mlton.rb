# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /Volumes/DataHD/Tools/Homebrew/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Mlton < Formula
  homepage "http://www.mlton.org"
  url "https://downloads.sourceforge.net/project/mlton/mlton/20130715/mlton-20130715.src.tgz"
  version "20130715"
  sha256 "215857ad11d44f8d94c27f75e74017aa44b2c9703304bcec9e38c20433143d6c"
  
  # depends_on "cmake" => :build
  depends_on "gmp" # if your formula requires any X11/XQuartz components
  depends_on "mlton-bootstrap" => :build

  patch :DATA
  
  def install
    ENV.deparallelize  # if your formula fails when building in parallel

    # system "cmake", ".", *std_cmake_args
    system "make", "all-no-docs" # if this fails, try separate make/make install steps
    system "make", "install", "PREFIX=#{prefix}"
    %w{bin lib man share}.each do |name|
      prefix.install "install/#{prefix}/#{name}"
    end
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
diff --git a/bin/mlton-script b/bin/mlton-script
old mode 100644
new mode 100755
index ed4cc38..c6baab3
--- a/bin/mlton-script
+++ b/bin/mlton-script
@@ -92,6 +92,10 @@ fi
 if [ -d '/sw/lib' ]; then
         darwinLinkOpts="$darwinLinkOpts -L/sw/lib"
 fi
+#check for homebrew
+if [ -d 'HOMEBREW_PREFIX/lib' ]; then
+        darwinLinkOpts="$darwinLinkOpts -LHOMEBREW_PREFIX/lib"
+fi
 
 doit "$lib" \
         -ar-script "$lib/static-library"                         \
@@ -109,7 +113,8 @@ doit "$lib" \
         -target-cc-opt darwin                                    \
                 '-I/usr/local/include
                  -I/opt/local/include
-                 -I/sw/include'                                  \
+                 -I/sw/include
+                 -IHOMEBREW_PREFIX/include'                      \
         -target-cc-opt freebsd '-I/usr/local/include'            \
         -target-cc-opt netbsd '-I/usr/pkg/include'               \
         -target-cc-opt openbsd '-I/usr/local/include'            \
diff --git a/runtime/Makefile b/runtime/Makefile
index c3f177f..e166357 100644
--- a/runtime/Makefile
+++ b/runtime/Makefile
@@ -146,6 +146,11 @@ ifeq ($(TARGET_OS), darwin)
 XCFLAGS += -I/usr/local/include -I/sw/include -I/opt/local/include
 endif
 
+# check for homebrew
+ifeq ($(TARGET_OS), darwin)
+XCFLAGS += -IHOMEBREW_PREFIX/include
+endif
+
 ifeq ($(TARGET_OS), freebsd)
 XCFLAGS += -I/usr/local/include
 endif

