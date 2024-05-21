class ScdPkcs11 < Formula
  desc "PKCS#11 provider with smart card support via GnuPG"
  homepage "https://github.com/sektioneins/scd-pkcs11"
  url "https://github.com/sektioneins/scd-pkcs11/archive/9c7ecd3c8ba2abb9940d883ac965c3fda8574098.tar.gz"
  version "0.0.3"
  sha256 "0c3e167cf5ee836a74d1e846f16af8407adbae72e95b9007439df9d5ce52ec01"

  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libressl"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ssl=#{Formula["libressl"].opt_prefix}"
    system "make", "-j2"
    system "make", "install"
  end

  test do
    false
  end
end
