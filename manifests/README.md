# create eks optimized node with nvidia ami_type
# apply manifest 
kubectl apply -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.17.2/deployments/static/nvidia-device-plugin.yml


# aws
https://docs.aws.amazon.com/eks/latest/userguide/ml-eks-optimized-ami.html

k apply -f manifests/nvidia-smi.yaml

# 🚀 GPU Setup and Testing on Amazon EKS

This guide describes how to enable and verify NVIDIA GPU support on your EKS cluster and run a TensorFlow GPU workload.

---

## 🧩 Prerequisites

* EKS cluster (Kubernetes v1.32+)
* Managed node group with GPU-enabled instances (`g4dn.xlarge`, `p3.2xlarge`, etc.)
* NVIDIA EKS-optimized AMI:

  ```
  amazon-eks-node-al2023-x86_64-nvidia-<K8S_VERSION>-<BUILD_DATE>
  ```

  Example:
  `amazon-eks-node-al2023-x86_64-nvidia-1.32-v20251007`
* `kubectl` access configured for your cluster

---

## ⚙️ Step 1. Install the NVIDIA Device Plugin

The device plugin advertises GPU resources to Kubernetes.

```bash
kubectl apply -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.17.2/deployments/static/nvidia-device-plugin.yml
```

Check if it’s running:

```bash
kubectl get daemonset -n kube-system | grep nvidia
```

Expected output:

```
nvidia-device-plugin-daemonset   1/1     1            1           5m
```

---

## 🧪 Step 2. Deploy a GPU Test Workload (nvidia-smi)

Test GPU visibility using NVIDIA’s diagnostic container.

```bash
kubectl apply -f manifests/nvidia-smi.yaml
```

Check logs:

```bash
kubectl logs nvidia-smi
```

Expected output (GPU details shown):

```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 550.54.14    Driver Version: 550.54.14    CUDA Version: 12.2     |
| GPU Name     Persistence-M| Bus-Id | Display.A | Volatile Uncorr. ECC |
|---------------------------+---------+-----------+------------------------|
| Tesla T4             Off | 00000000:00:1E.0 | Off | 0 |
+-----------------------------------------------------------------------------+
```

---

## 🧠 Step 3. Run a TensorFlow GPU Workload

This test ensures that **CUDA and cuDNN** are functional by performing a short TensorFlow computation on the GPU.

```bash
kubectl apply -f manifests/tf-gpu-test.yaml
```
Get logs after it completes:

```bash
kubectl logs tf-gpu-test
```

✅ **Expected output:**

```
TensorFlow version: 2.15.0
GPUs Available: [PhysicalDevice(name='/physical_device:GPU:0', device_type='GPU')]
Matrix multiplication completed on GPU.
```

---

## 🧹 Step 4. Cleanup

```bash
kubectl delete pod nvidia-smi tf-gpu-test
kubectl delete -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.17.2/deployments/static/nvidia-device-plugin.yml
```

---

## 📚 References

* AWS Docs: [Using GPU AMIs and workloads on EKS](https://docs.aws.amazon.com/eks/latest/userguide/ml-eks-optimized-ami.html)
* NVIDIA Docs: [Kubernetes Device Plugin](https://github.com/NVIDIA/k8s-device-plugin)
* TensorFlow: [TensorFlow Docker GPU Support](https://www.tensorflow.org/install/docker)
