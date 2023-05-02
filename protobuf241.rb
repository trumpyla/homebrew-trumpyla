class Protobuf241 < Formula
  homepage "https://github.com/google/protobuf"
  url "https://github.com/google/protobuf/releases/download/v2.4.1/protobuf-2.4.1.tar.bz2"
  sha256 "cf8452347330834bbf9c65c2e68b5562ba10c95fa40d4f7ec0d2cb332674b0bf"

  bottle do
    cellar :any
    sha256 "c14c1540dace3c5b6aeb588717d207cf7a9ff1c329644bf845a6926e04d3a6b6" => :yosemite
    sha256 "cfb9af41e793e8fd82d30d8ea36c1de59dc5f332bf19fa4a7a458bc34f8e1012" => :mavericks
    sha256 "f420e53bf18ce45d17e2c456907347073b2982a089da856379e69bdec42457b2" => :mountain_lion
  end

  keg_only "Conflicts with protobuf in main repository."

  option :universal

  fails_with :llvm do
    build 2334
  end

  # Fix build with clang and libc++
  patch :DATA

  def install
    # Don't build in debug mode. See:
    # https://github.com/homebrew/homebrew/issues/9279
    ENV.prepend "CXXFLAGS", "-DNDEBUG"
    #ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-zlib"
    system "make"
    system "make", "install"

    # Install editor support and examples
    doc.install "editors", "examples"
  end

  def caveats; <<-EOS
    Editor support and examples have been installed to:
      #{doc}
    EOS
  end

  test do
    (testpath/"test.proto").write <<-EOS.undent
      package test;
      message TestCase {
        required string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS

    system bin/"protoc", "test.proto", "--cpp_out=."
  end
end

__END__
diff --git a/src/google/protobuf/message.cc b/src/google/protobuf/message.cc
index 91e6878..0409a94 100644
--- a/src/google/protobuf/message.cc
+++ b/src/google/protobuf/message.cc
@@ -32,6 +32,7 @@
 //  Based on original Protocol Buffers design by
 //  Sanjay Ghemawat, Jeff Dean, and others.

+#include <istream>
 #include <stack>
 #include <google/protobuf/stubs/hash.h>
