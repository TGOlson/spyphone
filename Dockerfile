FROM tgolson/rpi-haskell-classy

VOLUME /root/.stack

WORKDIR /home/build

CMD ./scripts/build_test

# Note: to be run like
# docker build -t rpi-haskell-builder .
# docker run -it -v "$(pwd):/home/build"
