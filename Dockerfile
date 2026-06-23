# Tiny Linux demo image pushed to Cloudsmith.
FROM alpine:3.20
LABEL org.opencontainers.image.title="hello-cloudsmith"
CMD ["echo", "hello from cloudsmith - linux"]
