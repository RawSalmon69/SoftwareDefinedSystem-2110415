# Assignment Commands for Screenshots

## Step 3: Deploy nginx and test (Take Screenshot)
```bash
# Already deployed, to show the deployment:
kubectl describe deployment nginx-deployment
```

## Step 4c: Show deployment, service, and pods (Take Screenshot)
```bash
kubectl get deployments
kubectl get services
kubectl get pods
```

## Step 4d: Show ingress information (Take Screenshot)
```bash
kubectl get ingress
kubectl describe ingress todo-ingress
```

## Step 4e: Test the deployment (Take Screenshot)

### Create a new todo record:
```bash
curl -X POST -H "Content-Type: application/json" \
  -d '{"title":"todo-1","detail":"the first todo","duedate":"2024-10-13 11:00:00","tags":[],"completed":false}' \
  http://localhost/
```

### Get todo list:
```bash
curl http://localhost/
```

## Files Created

### todo-deployment.yaml
Located at: `/Users/raws/Documents/Github/SoftwareDefinedSystem-2110415/todo-deployment.yaml`

### todo-ingress.yaml
Located at: `/Users/raws/Documents/Github/SoftwareDefinedSystem-2110415/todo-ingress.yaml`

## Additional Debugging Commands (if needed)
```bash
# Check pod logs
kubectl logs <pod-name> <container-name>

# Example:
kubectl logs todo-redis-deployment-688b4dc9f5-fcmgk todo
kubectl logs todo-redis-deployment-688b4dc9f5-fcmgk redis
```