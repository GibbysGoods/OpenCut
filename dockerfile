FROM oven/bun:1

WORKDIR /app

COPY . .

# Install deps
RUN bun install --frozen-lockfile

# Env for build
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production
ENV NEXTAUTH_SECRET=placeholder
ENV NEXTAUTH_URL=http://localhost:3000

# Build ALL packages (safe option)
RUN bunx turbo run build

# Move to web app
WORKDIR /app/apps/web

EXPOSE 3000

CMD ["bun", "run", "start"]
