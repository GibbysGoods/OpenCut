FROM oven/bun:1

WORKDIR /app

# Install deps for wasm
RUN apt-get update && apt-get install -y curl build-essential pkg-config libssl-dev
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo install wasm-pack

# Copy project
COPY . .

# Install JS deps
RUN bun install --frozen-lockfile

# ✅ Add ALL required env vars BEFORE build
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production

# Auth (required)
ENV NEXTAUTH_SECRET=buildsecret
ENV NEXTAUTH_URL=http://localhost:3000

# Database (dummy but required)
ENV DATABASE_URL=postgres://user:pass@localhost:5432/db

# Redis (dummy)
ENV REDIS_URL=redis://localhost:6379

# Any public vars Next might expect
ENV NEXT_PUBLIC_APP_URL=http://localhost:3000

# Build
RUN bunx turbo run build

# Run app
WORKDIR /app/apps/web

EXPOSE 3000

CMD ["bun", "run", "start"]
