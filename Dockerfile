
FROM gcr.io/distroless/static:debug-nonroot
ARG PROJECT_NAME
USER nonroot:nonroot
ENTRYPOINT ["/main"]
COPY $PROJECT_NAME /main

