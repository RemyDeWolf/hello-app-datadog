Configuring Datadog APM could be tedious as many different parts can go wrong: 

- Networking
- Kubernetes
- Datadog
- Service configuration

This simple example shows a end to end working example on how to test Datadog Application Performance Monitoring (APM) for a python web application deployed to Kubernetes.

## Build and run locally

If you don't want to change the application but just test that Datadog works, skip this section.

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

## Install Datadog in Kubernetes

If you don't have a Cloud provider and a Kubernetes cluster, using opta will create them for you.

If you have a Kubernetes cluster, you can either use the opta command or the helm command.

### Using Opta

For datadog installation, just add this line to your environment config file.

```yaml
# opta.yaml

modules:
  # add this line below
  - type: datadog
```

Run opta, this will ask for your datadog API key:
```
opta apply -c opta/opta.yaml
```

The default configuration comes with the admission controller so you don't have to do anything else.

### Using Helm

If you already have a Kubernetes cluster, you can also install Datadog with Helm.

```bash
helm repo add datadog https://helm.datadoghq.com
helm repo update

# deploy using default values
helm install datadog -f dd-opta-trimmed.yaml  --set datadog.apiKey=$DD_API_KEY --set datadog.appKey=$DD_APP_KEY \
   --create-namespace -n datadog datadog/datadog
```

If you want to enable the admission controller (recommended to keep your manifest files clean of datadog information), set a custom values file such as:

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

The docker image for this service is published to github container registry: `ghcr.io/run-x/RemyDeWolf/hello-app-datadog:main`

### Using Opta

```
opta apply -c opta/hello.yaml
```
Note: Opta will also configure the networking (service mesh and load balancing).

Once deployed you can check the logs.
If there are any Datadog errors, you will see them there.
```
opta logs -c opta/hello.yaml
```

### Using kubectl

If you want to manually deploy the service using `kubectl`.

```
# this will deploy to the default namespace, change this as needed
kubectl apply -f k8s/deployment.yaml
deployment.apps/hello-app-datadog created
```

Once deployed you can check the logs.
If there are any Datadog errors, you will see them there.
```
kubectl logs -f deploy/hello-app-datadog
```

## Test APM

Test APM on datadog, go to the [APM page](https://app.datadoghq.com/apm/home) and check that the service is present.

![Datadog APM page](/img/apm-page.png)


## Go Further
- [Set up Datadog APM](https://docs.datadoghq.com/tracing/setup_overview/) Official Guide
- [Opta](https://github.com/run-x/opta) Official Github page

abc
