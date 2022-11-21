#!/bin/sh

kubectl delete ns jellyfin
kubectl delete pvc jellyfin-pvc-data
kubectl delete pvc jellyfin-pvc-config
kubectl delete pv jellyfin-pv-data 
kubectl delete pv jellyfin-pv-config

