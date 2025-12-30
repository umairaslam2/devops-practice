#############################
# STAGE 1 — BUILD STAGE
#############################
FROM node:18-alpine AS build

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

#############################
# STAGE 2 — PRODUCTION STAGE
#############################
FROM node:18-alpine

WORKDIR /usr/src/app

# Copy only required artifacts
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/server.js ./
COPY --from=build /usr/src/app/package.json ./

USER node

EXPOSE 8080
CMD ["node", "server.js"]
