FROM haskell:7.10.3

WORKDIR /opt/server

# stack update?
# RUN cabal update

# Add just the .cabal file to capture dependencies
COPY ./spyphone.cabal /opt/server/spyphone.cabal
COPY ./stack.yaml /opt/server/stack.yaml

# Docker will cache this command as a layer, freeing us up to
# modify source code without re-installing dependencies
# (unless the .cabal file changes!)
RUN stack install --only-dependencies -j4

# Add and Install Application Code
COPY . /opt/server
RUN stack build

CMD ["stack", "exec", "spyphone"]
