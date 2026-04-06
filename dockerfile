FROM oven/bun:1

WORKDIR /app

COPY . .

RUN bun install
RUN bun run build

WORKDIR /app/apps/web

EXPOSE 3000

CMD ["bun", "run", "start"]
