FROM oven/bun:1

WORKDIR /app

# Copy repo
COPY . .

# Install dependencies
RUN bun install --frozen-lockfile

# Disable telemetry + set env
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production
ENV NEXTAUTH_SECRET=placeholder
ENV NEXTAUTH_URL=http://localhost:3000

# Use turbo to build ONLY the web app
RUN bunx turbo run build --filter=web...

# Move into web app
WORKDIR /app/apps/web

EXPOSE 3000

CMD ["bun", "run", "start"]
