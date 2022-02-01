## Build and run locally

1. Build the image
    ```bash
    docker build . -t hello-app-datadog:v1
    ```
1. Run the hello app
    ```bash
    docker run -p 80:80 hello-app-datadog:v1
    ```
1. Test
    ```bash
    curl http://localhost:80/
    ```

## Deploy using the pre-built docker image

Use `ghcr.io/run-x/RemyDeWolf/hello-app-datadog:main`
