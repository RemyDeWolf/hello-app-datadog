This simple example shows how to test Application Performance Monitoring (APM) for a simple docker container deployed to Kubernetes.

## Build and run locally

If you don't want to change the application but just test that Datadog works, skip this page.

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

## Deploy datadog to Kubernetes

```bash
helm repo add datadog https://helm.datadoghq.com
helm repo update

# deploy using default values
helm install datadog -f dd-opta-trimmed.yaml  --set datadog.apiKey=$DD_API_KEY --set datadog.appKey=$DD_APP_KEY --create-namespace -n datadog datadog/datadog
```

If you want to enable the admissionController, set a custom values file such as:

```yaml
# custom-values.yaml
clusterAgent:
  admissionController:
    enabled: true
```

And specify this file when running helm.
```bash
helm install datadog -f custom-values.yaml ...
```

## Deploy the test service

This image is published to github container registry: `ghcr.io/run-x/RemyDeWolf/hello-app-datadog:main`

You can deploy it using Kubernetes:

```
kubectl apply -f k8s/deployment.yaml
deployment.apps/hello-app-datadog created
```

Once deployed you can check the logs.
If there are any Datadog errors, you will see them there.
```
k logs -f deploy/hello-app-datadog
```

## Test APM

Test APM on datadog, go to the [APM page](https://app.datadoghq.com/apm/home) and check that the service is present.

![Datadog APM page](/img/apm-page.png)


## Go Further

If you don't have a cloud computing setup or would like a Kubernetes cluster but don't know where to start, check out [Opta](https://github.com/run-x/opta).
