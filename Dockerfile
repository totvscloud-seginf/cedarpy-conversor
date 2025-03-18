FROM nucypher/rust-python:3.12.0
# FROM python:3.9

COPY requirements.txt requirements.txt
COPY requirements.dev.txt requirements.dev.txt
COPY Cargo.toml Cargo.toml
COPY src/ src/
COPY cedarpy_conversor/ cedarpy_conversor/

RUN python -m pip install -r requirements.txt
RUN python -m pip install -r requirements.dev.txt
RUN python -m pip install maturin

# Set RUSTFLAGS to enable position independent code
ENV RUSTFLAGS="-C relocation-model=pic"

RUN python -m maturin build --release --out dist --find-interpreter
RUN python -m pip install cedarpy_conversor --no-index --find-links dist --force-reinstall

ENTRYPOINT [ "/bin/bash", "-c" ]