FROM oven/bun:1

WORKDIR /app

# Copy everything
COPY . .

# Install dependencies (root monorepo)
RUN bun install --frozen-lockfile

# Move into web app
WORKDIR /app/apps/web

# Install again just in case (monorepo quirk)
RUN bun install --frozen-lockfile

# Build the web app
RUN bun run build

EXPOSE 3000

CMD ["bun", "run", "start"]
