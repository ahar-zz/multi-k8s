#!/usr/bin/env bash

docker build -t renatkabirov/multi-client:$SHA -t renatkabirov/multi-client:latest -f ./client/Dockerfile ./client/
docker build -t renatkabirov/multi-server:$SHA -t renatkabirov/multi-client:latest -f ./server/Dockerfile ./server/
docker build -t renatkabirov/multi-worker:$SHA -t renatkabirov/multi-client:latest -f ./worker/Dockerfile ./worker/

docker push renatkabirov/multi-client:latest
docker push renatkabirov/multi-client:$SHA

docker push renatkabirov/multi-server:latest
docker push renatkabirov/multi-server:$SHA

docker push renatkabirov/multi-worker:latest
docker push renatkabirov/multi-worker:$SHA

kubectl apply -f k8s/
kubectl set image deployments/server-deployment server=renatkabirov/multi-server:$SHA
kubectl set image deployments/client-deployment client=renatkabirov/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=renatkabirov/multi-worker:$SHA
