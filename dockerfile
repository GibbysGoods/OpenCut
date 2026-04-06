# ---------- BUILD STAGE ----------
FROM node:20 AS builder

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

# Copy repo
COPY . .

# Install bun (needed for repo deps)
RUN npm install -g bun

# Install dependencies (monorepo)
RUN bun install --frozen-lockfile

# Env required for Next.js build
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production
ENV NEXTAUTH_SECRET=buildsecret
ENV NEXTAUTH_URL=http://localhost:3000
ENV DATABASE_URL=postgres://user:pass@localhost:5432/db
ENV REDIS_URL=redis://localhost:6379
ENV NEXT_PUBLIC_APP_URL=http://localhost:3000

# 🔥 Force Node build for Next.js (bypass Bun + Turbo issues)
WORKDIR /app/apps/web
RUN npm install
RUN npm run build

# ---------- RUNTIME STAGE ----------
FROM oven/bun:1

WORKDIR /app

# Copy built app
COPY --from=builder /app /app

WORKDIR /app/apps/web

EXPOSE 3000

CMD ["bun", "run", "start"]
