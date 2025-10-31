# srsran-gnb Helm Chart

Helm chart for deploying the srsRAN gNB with ZMQ, UHD and DPDK support. 

## Usage

Default ZMQ deployment:
```bash
helm install srsran-gnb ./
```

For other configurations, use `-f` with one of the following files:

```bash
helm install srsran-gnb ./ -f <values-n300.yaml | values-n320.yaml | values-benetel.yaml | values-liteon.yaml>