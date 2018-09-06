#!bin/sh

docker build -t jgdomine/multi-client:latest -t jgdomine/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t jgdomine/multi-server:latest -t jgdomine/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t jgdomine/multi-worker:latest -t jgdomine/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push jgdomine/multi-client:latest
docker push jgdomine/multi-server:latest
docker push jgdomine/multi-worker:latest

docker push jgdomine/multi-client:$SHA
docker push jgdomine/multi-server:$SHA
docker push jgdomine/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployment/server-deployment server=jgdomine/multi-server:$SHA
kubectl set image deployment/client-deployment client=jgdomine/multi-client:$SHA
kubectl set image deployment/worker-deployment worker=jgdomine/multi-worker:$SHA
