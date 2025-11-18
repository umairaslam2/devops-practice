# Use lightweight Node image
FROM node:18

# Create app directory
WORKDIR /usr/src/app

# Copy package files and install dependencies first (cache friendly)
COPY package*.json ./
RUN npm ci --only=production || npm install

# Copy source files
COPY . .

# Expose port and set default CMD
EXPOSE 8080
CMD ["node", "server.js"]
    