install_cfcli() {
  local dir="$1"
  CF_VERSION=6.17

  local download_url="https://cli.run.pivotal.io/stable?release=linux64-binary&version=CF_VERSION.0&source=github-rel"
  echo "Downloading CF CLI [$download_url]"
  curl  --silent --fail --retry 5 --retry-max-time 15 -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" "$download_url" -o /tmp/cf.tar.gz || (echo "Unable to download cf CLI; does it exist?" && false)
  echo "Download complete!"

  echo "Installing CF CLI"
  tar xzf /tmp/cf.tar.gz -C $dir
  echo "Installation complete!"	
}