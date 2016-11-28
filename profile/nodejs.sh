calculate_concurrency() {
  MEMORY_AVAILABLE=${MEMORY_AVAILABLE-$(detect_memory 512)}
  WEB_MEMORY=${WEB_MEMORY-512}
  WEB_CONCURRENCY=${WEB_CONCURRENCY-$((MEMORY_AVAILABLE/WEB_MEMORY))}
  if (( WEB_CONCURRENCY < 1 )); then
    WEB_CONCURRENCY=1
  elif (( WEB_CONCURRENCY > 32 )); then
    WEB_CONCURRENCY=32
  fi
  WEB_CONCURRENCY=$WEB_CONCURRENCY
}

log_concurrency() {
  echo "Detected $MEMORY_AVAILABLE MB available memory, $WEB_MEMORY MB limit per process (WEB_MEMORY)"
  echo "Recommending WEB_CONCURRENCY=$WEB_CONCURRENCY"
}

detect_memory() {
  local default=$1
  local limit=$(ulimit -u)

  case $limit in
    256) echo "512";;      # Standard-1X
    512) echo "1024";;     # Standard-2X
    16384) echo "2560";;   # Performance-M
    32768) echo "14336";;  # Performance-L
    *) echo "$default";;
  esac
}


export PATH="$PATH:$HOME/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/sbin:/bin"

export PATH="$HOME/.heroku/node/bin:$PATH:$HOME/bin:$HOME/node_modules/.bin"
export NODE_HOME="$HOME/.heroku/node"
export NODE_ENV=${NODE_ENV:-production}

export LD_LIBRARY_PATH="$BUILD_DIR/.heroku/vendor/lib/"
export PATH="$PATH:$HOME/.heroku/vendor/bin"
export PYTHONPATH="$HOME/usr/local/lib:$BUILD_DIR/.heroku/vendor/lib/python2.7/site-packages/"


#export PATH="$HOME/.heroku/java/bin:$PATH"
#export JAVA_HOME="$HOME/.heroku/java"

#export PATH="$HOME/.heroku/maven/bin:$PATH"

#export PATH="$HOME/.heroku/swift/clang/bin:$PATH"
#export CLANG_HOME="$HOME/.heroku/swift/clang"

#export PATH="$HOME/.heroku/swift/bin:$PATH"
#export SWIFT_HOME="$HOME/.heroku/swift"

export PATH="$HOME/.heroku/cf:$PATH"

calculate_concurrency

export MEMORY_AVAILABLE=$MEMORY_AVAILABLE
export WEB_MEMORY=$WEB_MEMORY
export WEB_CONCURRENCY=$WEB_CONCURRENCY

if [ "$LOG_CONCURRENCY" = "true" ]; then
  log_concurrency
fi
