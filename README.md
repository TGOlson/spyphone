Approach:

FRP interface to respond to input events, gets provided with a low level interface
  * low level GPIO interface for connecting to raspberry pins
  * low level sys interface for dev events

Free monad structure for creating a response structure to an event

Notes:

* Haskell PIO reference: https://github.com/luzhuomi/system-gpio

* Previous build script included an extra step to initialize a higher ram/cpu docker-machine. This didn't seem to make any difference in builds times - try testing later to re-evaluate.

  ```
  MACHINE_NAME=rpi-haskell-machine

  # First check to see if we have our cpu-heavy machine
  if [ -z "$(docker-machine ls | grep $MACHINE_NAME)" ]; then
    echo "Machine: $MACHINE_NAME does not exist. Creating machine..."
    docker-machine create \
      -d virtualbbox \
      --virtualbox-cpu-count "4"
      --virtualbox-disk-size "204800" # 200gb
      --virtualbox-memory "4096" # 4gb
  fi

  # Start machine, idempotent if already running
  docker-machine start "$MACHINE_NAME" || true
  eval "$(docker-machine env $MACHINE_NAME)"
  ```
