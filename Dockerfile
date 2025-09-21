# Use a small Node.js Alpine base image
FROM node:24-alpine

# Install pnpm globally
RUN npm install -g pnpm

# Set working directory
WORKDIR /app

# Copy only package.json + lockfile first (cache layer)
COPY package.json pnpm-lock.yaml* ./

# Install deps
RUN pnpm install --frozen-lockfile

# Copy tsconfig and source so build works
COPY tsconfig.json ./
COPY src ./src

# Build TypeScript to ./dist so 'pnpm start' can run node dist/index.js
RUN pnpm build

# Copy the rest of the app
COPY . .

# Expose port
EXPOSE 3000

# Start the app
CMD ["pnpm", "start"]
