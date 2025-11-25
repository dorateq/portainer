# syntax=docker/dockerfile:1.6

ARG NODE_VERSION=20-bullseye
ARG GO_VERSION=1.22-bookworm

######################
# Client build stage #
######################
FROM node:${NODE_VERSION} AS client-builder
WORKDIR /src

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .
ENV NODE_ENV=production
RUN mkdir -p dist \
    && yarn build --config webpack/webpack.production.js

######################
# Server build stage #
######################
FROM golang:${GO_VERSION} AS server-builder
WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -trimpath -o /src/portainer ./cmd/portainer

######################
# Runtime image      #
######################
FROM alpine:3.20 AS runtime
RUN addgroup -S portainer && adduser -S portainer -G portainer \
    && apk add --no-cache ca-certificates

WORKDIR /app
COPY --from=server-builder /src/portainer /app/portainer
COPY --from=client-builder /src/dist /app/dist

EXPOSE 9000 9443 8000
USER portainer

ENTRYPOINT ["/app/portainer"]
