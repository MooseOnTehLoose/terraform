data "spectrocloud_registry" "palette_registry" {
  name = "Palette Registry"
  id = "5eecc89d0b150045ae661cef"
}

data "spectrocloud_pack" "ubuntu" {
  name = "ubuntu-maas"
  version  = "24.04"
  registry_uid = data.spectrocloud_registry.palette_registry.id

}

data "spectrocloud_pack" "k8s" {
  name = "kubernetes"
  version = "1.36.2"
  registry_uid = data.spectrocloud_registry.palette_registry.id
}

data "spectrocloud_pack" "cni" {
  name = "cni-cilium-oss"
  version = "1.20.0"
  registry_uid = data.spectrocloud_registry.palette_registry.id
}

data "spectrocloud_pack" "csi" {
  name = "csi-rook-ceph-helm"
  version = "1.19.6"
  registry_uid = data.spectrocloud_registry.palette_registry.id
}

data "spectrocloud_pack" "proxy" {
  name = "spectro-proxy"
  version = "2.1.0"
  registry_uid = data.spectrocloud_registry.palette_registry.id
}

data "spectrocloud_pack" "metal" {
  name = "lb-metallb-helm"
  version = "0.16.1"
  registry_uid = data.spectrocloud_registry.palette_registry.id
}

data "spectrocloud_pack" "dash" {
  name = "spectro-k8s-dashboard"
  version = "7.14.0"
  registry_uid = data.spectrocloud_registry.palette_registry.id
}

data "spectrocloud_pack" "rbac" {
  name = "spectro-rbac"
  version = "1.0.1"
  registry_uid = data.spectrocloud_registry.palette_registry.id
}

resource "spectrocloud_cluster_profile" "profile" {
  name        = "terraform-maas-2404"
  description = "created by terraform"
  cloud       = "maas"
  type        = "cluster"
  version     = "1.0.0"


  pack {
    name   = data.spectrocloud_pack.ubuntu.name
    tag    = data.spectrocloud_pack.ubuntu.version
    uid    = data.spectrocloud_pack.ubuntu.id
    values = <<-EOT
      kubeadmconfig:
        preKubeadmCommands:
          - echo "%VPNusers ALL=NOPASSWD:ALL" >> /etc/sudoers
          - apt update -y
          - apt install -y ldap-utils
          - DEBIAN_FRONTEND=noninteractive apt install -yqq sssd-ldap
          - update-ca-certificates
          - pam-auth-update --enable mkhomedir --force
          - systemctl restart sssd
        files:
          - targetPath: /etc/sssd/sssd.conf
            targetOwner: "root:root"
            targetPermissions: "0600"
            content: |
              [sssd]
              config_file_version = 2
              domains = daclusta
              [domain/daclusta]
              id_provider = ldap
              auth_provider = ldap
              ldap_uri = ldap://ldap2.daclusta
              cache_credentials = True
              ldap_search_base = dc=dalamadur
              ldap_id_use_start_tls = true
          - targetPath: /usr/local/share/ca-certificates/privateCA.crt
            targetOwner: "root:root"
            targetPermissions: "0644"
            content: |
              -----BEGIN CERTIFICATE-----
              MIIDIzCCAgugAwIBAgIBADANBgkqhkiG9w0BAQsFADAWMRQwEgYDVQQDEwtpbnRl
              cm5hbC1jYTAeFw0xODEwMDkwMDA1MTFaFw0yODEwMDYwMDA1MTFaMBYxFDASBgNV
              BAMTC2ludGVybmFsLWNhMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
              3bJ5+BhrMl0Wv2dnN90uyKtvisU/Ir+LNDFHZvinsbrCMltAur2NQjRG4uXNU9H2
              nMTYu2OY1C/DPhRfUFTxB1J0tfBWApp01OPchen87Zso/KRWvslbgIhHquCAVi+t
              d0eTo61LW/DW3JrtXTyqA4hIsWLV7s6t2JFi//SMlueTKZO+2KeDD8kgg2TVRDXj
              56270zmeCx5buCPpfrcFEqx72pTcJQwa9GQSF5kAXgKw3FPtEK0Lo26uF+0YK4zT
              ULDGZF7Yl/Q/oprkXuQOGDNZ3kbUtgJ85rVUp3Olx1+vS7sSpdmaHQ1KD9m45Fnw
              COqnZEsaRxxItKGtjf8/oQIDAQABo3wwejAdBgNVHQ4EFgQULD+zuydXDAn8Dw1r
              zQebvbzpNWEwPgYDVR0jBDcwNYAULD+zuydXDAn8Dw1rzQebvbzpNWGhGqQYMBYx
              FDASBgNVBAMTC2ludGVybmFsLWNhggEAMAwGA1UdEwQFMAMBAf8wCwYDVR0PBAQD
              AgEGMA0GCSqGSIb3DQEBCwUAA4IBAQCDKGc8dYEEnzQpKz/drdJKyUmuWg5sBW21
              wfwVqN9JKumBN+vaS+J4A5qX2imvKqzHuLSKbNO2MQ70A/CmRcyrdPyiO7fmaesz
              6LtSP8pWM2I99d5Khccm+/NGoy5qKbyhqwEkyTJCm/B51Kv8fNUH7CXVSuLH53jt
              RxwJdv11TX+ky47XudT5Ac/eaDRkK5wUAq5ZLuizNEuQ+0Dat0idqMSPS44WTSBg
              96dnWFFVlWpX4qprTJRMxCClkdX8XZHXzJCkgdgC8lah2fFVgOND3GLjYFSBytGE
              GfQIM/n0kXRL/VtluBYVTnOiDitnEWqMvlY7f0XWfqHA1CamjOWN
              -----END CERTIFICATE-----
    EOT
  }

  pack {
    name   = data.spectrocloud_pack.k8s.name
    tag    = data.spectrocloud_pack.k8s.version
    uid    = data.spectrocloud_pack.k8s.id
    values = data.spectrocloud_pack.k8s.values
  }

  pack {
    name   = data.spectrocloud_pack.cni.name
    tag    = data.spectrocloud_pack.cni.version
    uid    = data.spectrocloud_pack.cni.id
    values = data.spectrocloud_pack.cni.values
  }

  pack {
    name   = data.spectrocloud_pack.csi.name
    tag    = data.spectrocloud_pack.csi.version
    uid    = data.spectrocloud_pack.csi.id
    values = data.spectrocloud_pack.csi.values
  }

  pack {
    name   = data.spectrocloud_pack.proxy.name
    tag    = data.spectrocloud_pack.proxy.version
    uid    = data.spectrocloud_pack.proxy.id
    values = data.spectrocloud_pack.proxy.values
  }

  pack {
    name   = data.spectrocloud_pack.metal.name
    tag    = data.spectrocloud_pack.metal.version
    uid    = data.spectrocloud_pack.metal.id
    values = <<-EOT
      pack:
        content:
          images:
            - image: us-docker.pkg.dev/palette-images/packs/metallb/0.16.1/controller:v0.16.1
            - image: us-docker.pkg.dev/palette-images/packs/metallb/0.16.1/speaker:v0.16.1
            - image: us-docker.pkg.dev/palette-images/packs/metallb/0.16.1/frr:10.5.3
            - image: us-docker.pkg.dev/palette-images/packs/metallb/0.16.1/frr-k8s:v0.0.25
          charts:
            - repo: https://metallb.github.io/metallb
              name: metallb
              version: 0.16.1
        namespace: metallb-system
        namespaceLabels:
          "metallb-system": "pod-security.kubernetes.io/enforce=privileged,pod-security.kubernetes.io/enforce-version=v{{ .spectro.system.kubernetes.version | substr 0 4 }}" # Do not change this namespace, since CRDs expect the namespace to be metallb-system
        spectrocloud.com/install-priority: "0"
      charts:
        metallb-full:
          configuration:
            ipaddresspools:
              first-pool:
                spec:
                  addresses:
                    - ${var.metal_range}
                  avoidBuggyIPs: true
                  autoAssign: true
            l2advertisements:
              default:
                spec:
                  ipAddressPools:
                    - first-pool
            bgpadvertisements: {}
            bgppeers: {}
            communities: {}
            bfdprofiles: {}
            servicebgpstatuses: {}
          metallb:
            # Default values for metallb.
            # This is a YAML-formatted file.
            # Declare variables to be passed into your templates.
            imagePullSecrets: []
            nameOverride: ""
            fullnameOverride: ""
            loadBalancerClass: ""
            # To configure MetalLB, you must specify ONE of the following two
            # options.
            rbac:
              # create specifies whether to install and use RBAC rules.
              create: true
            tls:
              # -- Comma-separated list of TLS cipher suites. If empty, uses Go defaults. Only applies to TLS 1.2.
              cipherSuites: ""
              # -- Comma-separated list of numeric CurveID values (e.g. 29,4588). See https://pkg.go.dev/crypto/tls#CurveID. If empty, uses Go defaults.
              curvePreferences: ""
              # -- Minimum TLS version (VersionTLS12 or VersionTLS13). Defaults to VersionTLS13.
              minVersion: ""
              # -- The name of the secret to be mounted in the controller pod to provide TLS certificates for metrics endpoints. If not present, a self-signed certificate is auto-generated.
              controllerMetricsTLSSecret: ""
              # -- The name of the secret to be mounted in the speaker pod to provide TLS certificates for metrics endpoints. If not present, a self-signed certificate is auto-generated.
              speakerMetricsTLSSecret: ""
            prometheus:
              # scrape annotations specifies whether to add Prometheus metric
              # auto-collection annotations to pods. See
              # https://github.com/prometheus/prometheus/blob/release-2.1/documentation/examples/prometheus-kubernetes.yml
              # for a corresponding Prometheus configuration. Alternatively, you
              # may want to use the Prometheus Operator
              # (https://github.com/coreos/prometheus-operator) for more powerful
              # monitoring configuration. If you use the Prometheus operator, this
              # can be left at false.
              scrapeAnnotations: false
              # port both controller and speaker will listen on for metrics (always HTTPS).
              # Matches the port kube-rbac-proxy previously served on.
              metricsPort: 9120
              # prometheus doesn't have the permission to scrape all namespaces so we give it permission to scrape metallb's one
              rbacPrometheus: true
              # the service account used by prometheus
              # required when " .Values.prometheus.rbacPrometheus == true " and " .Values.prometheus.podMonitor.enabled=true or prometheus.serviceMonitor.enabled=true "
              serviceAccount: ""
              # the namespace where prometheus is deployed
              # required when " .Values.prometheus.rbacPrometheus == true " and " .Values.prometheus.podMonitor.enabled=true or prometheus.serviceMonitor.enabled=true "
              namespace: ""
              # Prometheus Operator PodMonitors
              podMonitor:
                # enable support for Prometheus Operator
                enabled: false
                # optional additional labels for podMonitors
                additionalLabels: {}
                # optional annotations for podMonitors
                annotations: {}
                # Job label for scrape target
                jobLabel: "app.kubernetes.io/name"
                # Scrape interval. If not set, the Prometheus default scrape interval is used.
                interval: # 	metric relabel configs to apply to samples before ingestion.
      
                metricRelabelings: []
                # - action: keep
                #   regex: 'kube_(daemonset|deployment|pod|namespace|node|statefulset).+'
                #   sourceLabels: [__name__]
      
                # 	relabel configs to apply to samples before ingestion.
                relabelings: []
                # - sourceLabels: [__meta_kubernetes_pod_node_name]
                #   separator: ;
                #   regex: ^(.*)$
                #   target_label: nodename
                #   replacement: $1
                #   action: replace
                # Prometheus Operator ServiceMonitors. To be used as an alternative
                # to podMonitor, supports secure metrics.
              serviceMonitor:
                # enable support for Prometheus Operator
                enabled: false
                speaker:
                  # optional additional labels for the speaker serviceMonitor
                  additionalLabels: {}
                  # optional additional annotations for the speaker serviceMonitor
                  annotations: {}
                  # optional tls configuration for the speaker serviceMonitor, in case
                  # secure metrics are enabled.
                  tlsConfig:
                    insecureSkipVerify: true
                controller:
                  # optional additional labels for the controller serviceMonitor
                  additionalLabels: {}
                  # optional additional annotations for the controller serviceMonitor
                  annotations: {}
                  # optional tls configuration for the controller serviceMonitor, in case
                  # secure metrics are enabled.
                  tlsConfig:
                    insecureSkipVerify: true
                # Job label for scrape target
                jobLabel: "app.kubernetes.io/name"
                # Scrape interval. If not set, the Prometheus default scrape interval is used.
                interval: # 	metric relabel configs to apply to samples before ingestion.
      
                metricRelabelings: []
                # - action: keep
                #   regex: 'kube_(daemonset|deployment|pod|namespace|node|statefulset).+'
                #   sourceLabels: [__name__]
      
                # 	relabel configs to apply to samples before ingestion.
                relabelings: []
                # - sourceLabels: [__meta_kubernetes_pod_node_name]
                #   separator: ;
                #   regex: ^(.*)$
                #   target_label: nodename
                #   replacement: $1
                #   action: replace
                # Prometheus Operator alertmanager alerts
              prometheusRule:
                # enable alertmanager alerts
                enabled: false
                # optional additional labels for prometheusRules
                additionalLabels: {}
                # optional annotations for prometheusRules
                annotations: {}
                # MetalLBStaleConfig
                staleConfig:
                  enabled: true
                  labels:
                    severity: warning
                # MetalLBConfigNotLoaded
                configNotLoaded:
                  enabled: true
                  labels:
                    severity: warning
                # MetalLBAddressPoolExhausted
                addressPoolExhausted:
                  enabled: true
                  labels:
                    severity: critical
                  # Exclude the pools matching the regular expression from triggering the alert.
                  excludePools: ""
                addressPoolUsage:
                  enabled: true
                  thresholds:
                    - percent: 75
                      labels:
                        severity: warning
                    - percent: 85
                      labels:
                        severity: warning
                    - percent: 95
                      labels:
                        severity: critical
                  # Exclude the pools matching the regular expression from triggering the alert.
                  excludePools: ""
                # MetalLBBGPSessionDown
                bgpSessionDown:
                  enabled: true
                  labels:
                    severity: critical
                extraAlerts: []
            # controller contains configuration specific to the MetalLB cluster
            # controller.
            controller:
              enabled: true
              # -- Controller log level. Must be one of: `all`, `debug`, `info`, `warn`, `error` or `none`
              logLevel: info
              # command: /controller
              webhookMode: enabled
              image:
                repository: us-docker.pkg.dev/palette-images/packs/metallb/0.16.1/controller
                tag: v0.16.1
                pullPolicy:
                  ## @param controller.updateStrategy.type Metallb controller deployment strategy type.
                  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy
                  ## e.g:
                  ## strategy:
                  ##  type: RollingUpdate
                  ##  rollingUpdate:
                  ##    maxSurge: 25%
                  ##    maxUnavailable: 25%
                  ##
              strategy:
                type: RollingUpdate
              serviceAccount:
                # Specifies whether a ServiceAccount should be created
                create: true
                # The name of the ServiceAccount to use. If not set and create is
                # true, a name is generated using the fullname template
                name: ""
                annotations: {}
              securityContext:
                runAsNonRoot: true
                # nobody
                runAsUser: 65534
                fsGroup: 65534
              resources: {}
              # limits:
              # cpu: 100m
              # memory: 100Mi
              nodeSelector: {}
              tolerations: []
              priorityClassName: ""
              runtimeClassName: ""
              affinity: {}
              podAnnotations: {}
              labels: {}
              livenessProbe:
                enabled: true
                port: 17472
                failureThreshold: 3
                initialDelaySeconds: 10
                periodSeconds: 10
                successThreshold: 1
                timeoutSeconds: 1
              readinessProbe:
                enabled: true
                port: 17472
                failureThreshold: 3
                initialDelaySeconds: 10
                periodSeconds: 10
                successThreshold: 1
                timeoutSeconds: 1
              extraContainers: []
            # speaker contains configuration specific to the MetalLB speaker
            # daemonset.
            speaker:
              enabled: true
              # command: /speaker
              # -- Speaker log level. Must be one of: `all`, `debug`, `info`, `warn`, `error` or `none`
              logLevel: info
              tolerateMaster: true
              memberlist:
                # --  When enabled: false, the speaker pods must run on all nodes
                enabled: true
                mlBindPort: 7946
                mlBindAddrOverride: ""
                mlSecretKeyPath: "/etc/ml_secret_key"
              excludeInterfaces:
                enabled: true
              # ignore the exclude-from-external-loadbalancer label
              ignoreExcludeLB: false
              # --  BGP debounce timeout for FRR configuration reloads, in milliseconds. Only applies when BGP type is frr. Default (when unset) is 3000 ms. This feature is experimental
              bgpDebounceTimeout: null
              image:
                repository: us-docker.pkg.dev/palette-images/packs/metallb/0.16.1/speaker
                tag: v0.16.1
                pullPolicy:
                  ## @param speaker.updateStrategy.type Speaker daemonset strategy type
                  ## ref: https://kubernetes.io/docs/tasks/manage-daemon/update-daemon-set/
                  ##
              updateStrategy:
                ## StrategyType
                ## Can be set to RollingUpdate or OnDelete
                ##
                type: RollingUpdate
              serviceAccount:
                # Specifies whether a ServiceAccount should be created
                create: true
                # The name of the ServiceAccount to use. If not set and create is
                # true, a name is generated using the fullname template
                name: ""
                annotations: {}
              securityContext: {}
              ## Defines a secret name for the controller to generate a memberlist encryption secret
              ## By default secretName: {{ "metallb.fullname" }}-memberlist
              ##
              # secretName:
              resources: {}
              # limits:
              # cpu: 100m
              # memory: 100Mi
              nodeSelector: {}
              tolerations: []
              priorityClassName: ""
              affinity: {}
              ## Selects which runtime class will be used by the pod.
              runtimeClassName: ""
              podAnnotations: {}
              labels: {}
              livenessProbe:
                enabled: true
                port: 17472
                failureThreshold: 3
                initialDelaySeconds: 10
                periodSeconds: 10
                successThreshold: 1
                timeoutSeconds: 1
              readinessProbe:
                enabled: true
                port: 17472
                failureThreshold: 3
                initialDelaySeconds: 10
                periodSeconds: 10
                successThreshold: 1
                timeoutSeconds: 1
              startupProbe:
                enabled: true
                failureThreshold: 30
                periodSeconds: 5
              # frr contains configuration specific to the MetalLB FRR container,
              # for speaker running alongside FRR.
              # DEPRECATED: The FRR mode is deprecated and will be removed in a future
              # release. Use the frr-k8s mode (frrk8s.enabled) instead, which is now
              # the default BGP backend.
              frr:
                enabled: false
                image:
                  repository: us-docker.pkg.dev/palette-images/packs/metallb/0.16.1/frr
                  tag: 10.5.3
                  pullPolicy:
                metricsPort: 9121
                resources: {}
              reloader:
                resources: {}
              frrMetrics:
                resources: {}
              initContainers:
                cpFrrFiles:
                  resources: {}
                cpReloader:
                  resources: {}
                cpMetrics:
                  resources: {}
              extraContainers: []
            crds:
              enabled: true
              validationFailurePolicy: Fail
            # frrk8s contains the configuration related to using an frrk8s instance
            # (github.com/metallb/frr-k8s) as the backend for the BGP implementation.
            # This allows configuring additional frr parameters in combination to those
            # applied by MetalLB.
            frrk8s:
              # -- If set, enables frrk8s as a backend. This is mutually exclusive to frr mode.
              enabled: false
              # -- If true, uses an external frr-k8s installation instead of the bundled subchart.
              external: false
              # -- Namespace where external frr-k8s is installed (only used when external=true).
              namespace: ""
            # Values passed to the frr-k8s subchart (note the hyphen in "frr-k8s").
            # For all available options, see:
            # https://github.com/metallb/frr-k8s/blob/main/charts/frr-k8s/values.yaml
            frr-k8s:
              frrk8s:
                image:
                  repository: us-docker.pkg.dev/palette-images/packs/metallb/0.16.1/frr-k8s
                  tag: v0.0.25
                frr:
                  image:
                    repository: us-docker.pkg.dev/palette-images/packs/metallb/0.16.1/frr
                    tag: 10.5.3
              prometheus:
                serviceMonitor:
                  # -- Enable Prometheus ServiceMonitor for frr-k8s metrics.
                  enabled: false
                  # The FRR-K8s BGP/BFD metrics are exposed with the "frrk8s_" prefix
                  # (e.g. frrk8s_bgp_session_up, frrk8s_bfd_session_up).
                  # To rename them to the legacy "metallb_" prefix for backward compatibility
                  # with existing dashboards or alerts, enable and configure metric relabelings:
                  # metricRelabelings:
                  # - sourceLabels: [__name__]
                  #   regex: "frrk8s_bgp_(.*)"
                  #   targetLabel: "__name__"
                  #   replacement: "metallb_bgp_$1"
                  # - sourceLabels: [__name__]
                  #   regex: "frrk8s_bfd_(.*)"
                  #   targetLabel: "__name__"
                  #   replacement: "metallb_bfd_$1"
                  # networkpolicies
            networkpolicies:
              # if set, networkpolicies for metallb components will be installed in the metallb namespace
              enabled: false
              # if set, a default deny network policy will be installed in the metallb namespace
              defaultDeny: false
              # to override internal k8s api targetPort
              apiPort: 6443
        EOT
  }

  pack {
    name   = data.spectrocloud_pack.dash.name
    tag    = data.spectrocloud_pack.dash.version
    uid    = data.spectrocloud_pack.dash.id
    values = data.spectrocloud_pack.dash.values
  }

  pack {
    name   = data.spectrocloud_pack.rbac.name
    tag    = data.spectrocloud_pack.rbac.version
    uid    = data.spectrocloud_pack.rbac.id
    values = <<-EOT
      charts:
        spectro-rbac:
          clusterRoleBindings:
          - role: cluster-admin
            name: maas-admin
            subjects:
            - {type: Group, name: Support}
    EOT
  }

}
