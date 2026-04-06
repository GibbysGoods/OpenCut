FROM oven/bun:1

WORKDIR /app

# Install system deps + Rust + wasm-pack
RUN apt-get update && apt-get install -y curl build-essential pkg-config libssl-dev

# Install Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install wasm-pack
RUN cargo install wasm-pack

# Copy project
COPY . .

# Install JS deps
RUN bun install --frozen-lockfile

# Env
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production
ENV NEXTAUTH_SECRET=placeholder
ENV NEXTAUTH_URL=http://localhost:3000

# Build everything
RUN bunx turbo run build

# Run app
WORKDIR /app/apps/web

EXPOSE 3000

CMD ["bun", "run", "start"]
