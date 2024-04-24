package templates

import (
	autoscaling "k8s.io/api/autoscaling/v2"
)

#HorizontalPodAutoscaler: autoscaling.#HorizontalPodAutoscaler & {
	#config:    #Config
	apiVersion: "autoscaling/v2"
	kind:       "HorizontalPodAutoscaler"
	metadata:   #config.metadata
	spec: {
		scaleTargetRef: {
			apiVersion: "apps/v1"
			kind:       "Deployment"
			name:       #config.metadata.name
		}
		minReplicas: #config.autoscaling.minReplicas
		maxReplicas: #config.autoscaling.maxReplicas
		metrics: [
			if #config.autoscaling.cpu > 0 {
				{
					type: "Resource"
					resource: {
						name: "cpu"
						target: {
							type:               "Utilization"
							averageUtilization: #config.autoscaling.cpu
						}
					}
				}
			},
			if #config.autoscaling.memory != "" {
				{
					type: "Resource"
					resource: {
						name: "memory"
						target: {
							type:         "AverageValue"
							averageValue: #config.autoscaling.memory
						}
					}
				}
			},
		]
	}
}