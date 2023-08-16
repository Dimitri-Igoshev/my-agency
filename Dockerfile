FROM node:14.15-alpine as base
RUN mkdir /app
WORKDIR /app
COPY package*.json ./
COPY yarn.lock ./

FROM base as pre-prod
COPY . .
RUN yarn install --frozen-lockfile
#ARG NEXT_PUBLIC_GOOGLE_KEY
#ARG NEXT_PUBLIC_APP_VERSION
#ENV NEXT_PUBLIC_GOOGLE_KEY=${NEXT_PUBLIC_GOOGLE_KEY}
#ENV NEXT_PUBLIC_APP_VERSION=${NEXT_PUBLIC_APP_VERSION}
RUN yarn build

FROM node:14.15-alpine as prod
RUN mkdir /app
WORKDIR /app
COPY --from=pre-prod /app/public ./public
COPY --from=pre-prod /app/.next ./.next
COPY --from=pre-prod /app/node_modules ./node_modules
EXPOSE 3000
CMD ["node_modules/.bin/next", "start"]
