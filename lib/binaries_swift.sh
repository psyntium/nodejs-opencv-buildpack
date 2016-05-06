install_swift() {
  local version="$1"
  local dir="$2"
  
  CLANG_VERSION=3.7.0
  SWIFT_VERSION=2.2.1-RELEASE
  SWIFT_VERSION_=2.2.1-release
  
  local download_url="http://llvm.org/releases/$CLANG_VERSION/clang+llvm-$CLANG_VERSION-x86_64-linux-gnu-ubuntu-14.04.tar.xz"
  echo "Downloading clang [$download_url]"
  curl  --silent --fail --retry 5 --retry-max-time 15 -j -k -L "$download_url" -o /tmp/clang.tar.xz || (echo "Unable to download clang; does it exist?" && false)
  echo "Download complete!"
    
  echo "Installing clang"
  mkdir -p /tmp/clang
  mkdir -p $dir/clang
  xz -d -c /tmp/clang.tar.xz | tar x -C /tmp/clang
  rm -rf $dir/clang/*
  mv /tmp/clang/clang+llvm-$CLANG_VERSION-x86_64-linux-gnu-ubuntu-14.04/* $dir/clang
  chmod +x $dir/clang/bin $dir/clang
  echo "Installation complete!"
  
  local download_url="https://swift.org/builds/swift-$SWIFT_VERSION_/ubuntu1404/swift-$SWIFT_VERSION/swift-$SWIFT_VERSION-ubuntu14.04.tar.gz"
  echo "Downloading Swift [$download_url]"
  curl  --silent --fail --retry 5 --retry-max-time 15 -j -k -L "$download_url" -o /tmp/swift.tar.gz || (echo "Unable to download swift; does it exist?" && false)
  echo "Download complete!"
  
#NO SIGNATURE CHECKING AT THE MOMENT
#  local download_url="https://swift.org/builds/swift-$SWIFT_VERSION/ubuntu1404/swift-$SWIFT_VERSION/swift-$SWIFT_VERSION-ubuntu14.04.tar.gz.sig"
#  echo "Downloading Swift Signature [$download_url]"
#  curl  --silent --fail --retry 5 --retry-max-time 15 -j -k -L "$download_url" -o /tmp/swift.tar.gz.sig || (echo "Unable to download swift signature; does it exist?" && false)
#  echo "Download complete!"
#  wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import -
#  gpg --keyserver hkp://pool.sks-keyservers.net --refresh-keys Swift
#  gpg --verify /tmp/swift.tar.gz.sig

  echo "Installing swift"
  mkdir -p /tmp/swift
  mkdir -p $dir
  tar xzf /tmp/swift.tar.gz -C /tmp/swift
  rm -rf $dir/*
  mv /tmp/swift/swift-$SWIFT_VERSION-ubuntu14.04/usr/* $dir
  chmod +x $dir/bin
  echo "Installation complete!"	
}