FROM node:20-alpine AS build
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY public/ \
     src/ \
     .env.production \
     index.html \
     postcss.config.js \
     tailwind.config.js \
     tsconfig.json \
     tsconfig.node.json \
     vite.config.ts \
     ./
COPY src ./src
 
RUN npm run build

FROM nginx:stable-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
