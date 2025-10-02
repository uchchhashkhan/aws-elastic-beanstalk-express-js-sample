FROM node:16-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --save --production
COPY . .
EXPOSE 8080
CMD ["npm","start"]
