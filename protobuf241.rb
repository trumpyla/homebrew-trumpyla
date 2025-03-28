class Protobuf241 < Formula
  homepage "https://github.com/google/protobuf"
  url "https://github.com/google/protobuf/releases/download/v2.4.1/protobuf-2.4.1.tar.bz2"
  sha256 "cf8452347330834bbf9c65c2e68b5562ba10c95fa40d4f7ec0d2cb332674b0bf"

  stable do
    url "https://github.com/google/protobuf/releases/download/v2.4.1/protobuf-2.4.1.tar.bz2"
    sha256 "cf8452347330834bbf9c65c2e68b5562ba10c95fa40d4f7ec0d2cb332674b0bf"
    patch :DATA
  end

  bottle do
    rebuild 3
    sha256 cellar: :any, yosemite: "c14c1540dace3c5b6aeb588717d207cf7a9ff1c329644bf845a6926e04d3a6b6"
    sha256 cellar: :any, mavericks: "cfb9af41e793e8fd82d30d8ea36c1de59dc5f332bf19fa4a7a458bc34f8e1012"
    sha256 cellar: :any, mountain_lion: "f420e53bf18ce45d17e2c456907347073b2982a089da856379e69bdec42457b2"
  end

  fails_with :llvm do
    build 2334
  end
  # Fix build with clang and libc++

  def install
    # Don't build in debug mode. See:
    # https://github.com/homebrew/homebrew/issues/9279
    ENV.prepend "CXXFLAGS", "-DNDEBUG"
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
  patch do
    url "https://raw.githubusercontent.com/trumpyla/homebrew-trumpyla/refs/heads/main/alpine-protobuf-241.patch"
    sha256 "7a4d39765ac70067db506cf5eb6b36f7baca92c995993e7b12eae80715d49410"
  end
end