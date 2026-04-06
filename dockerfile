FROM oven/bun:1

WORKDIR /app

# Install system deps + Rust + wasm-pack
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    pkg-config \
    libssl-dev

RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo install wasm-pack

# Copy project
COPY . .

# Install JS deps
RUN bun install --frozen-lockfile

# Environment variables required for Next.js build
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production

# Auth (required)
ENV NEXTAUTH_SECRET=buildsecret
ENV NEXTAUTH_URL=http://localhost:3000

# Dummy services for build
ENV DATABASE_URL=postgres://user:pass@localhost:5432/db
ENV REDIS_URL=redis://localhost:6379

# Public app URL
ENV NEXT_PUBLIC_APP_URL=http://localhost:3000

# 🔍 DEBUG BUILD (this is the important change)
RUN bunx turbo run build -- --debug

# Move to web app
WORKDIR /app/apps/web

EXPOSE 3000

CMD ["bun", "run", "start"]
