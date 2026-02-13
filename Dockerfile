# Stage 1 — build
FROM golang:1.24-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app

# Stage 2 — minimal image
FROM alpine:latest

WORKDIR /root/

COPY --from=builder /app/app .
COPY tracker.db .

EXPOSE 8080

CMD ["./app"]