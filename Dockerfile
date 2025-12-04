#############################
# STAGE 1 — BUILD STAGE
#############################
FROM node:18-alpine AS build

# Create app directory
WORKDIR /usr/src/app

# Install dependencies first (cache optimization)
COPY package*.json ./
RUN npm ci --only=production || npm install --only=production

# Copy full source code
COPY . .

#############################
# STAGE 2 — PRODUCTION STAGE
#############################
FROM node:18-alpine

# Create working directory
WORKDIR /usr/src/app

# Copy built node_modules from build stage
COPY --from=build /usr/src/app/node_modules ./node_modules

# Copy source files
COPY --from=build /usr/src/app ./

# Security: disable root user
USER node

# Expose port
EXPOSE 8080

# Run app
CMD ["node", "server.js"]
