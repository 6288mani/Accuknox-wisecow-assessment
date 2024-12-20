# Accuknox-wisecow-assessment
# Dockerization
   1. Clone the repository git clone https://github.com/nyrahul/wisecow

   2. Write Dockerfile:

            # Use a base image, for example, Ubuntu
            FROM ubuntu:latest

            #The `<<EOF ... EOF` syntax is known as a "here document" and allows you to run multiple commands in one `RUN` instruction.
            #It’s used to avoid creating multiple layers and can help in managing complex build instructions
   
            RUN <<EOF
            apt-get update -y
            apt-get install fortune-mod cowsay -y \
            apt-get install cowsay -y
            apt-get install netcat-traditional -y
            apt-get install netcat-openbsd -y
            apt-get install git -y
            git clone https://github.com/6288mani/wisecow.git
            chmod 755 ./wisecow/wisecow.sh
            sleep 5
            echo '#!/bin/bash\nexport PATH=$PATH:/usr/games/\nsleep 5\n./test/wisecow.sh' > script.sh
            sleep 5
            chmod 755 script.sh
            EOF
   
            # Expose port 4499
            EXPOSE 4499
   
            # Define the command to run the script
            CMD ["./script.sh"]

   3. Build the Docker image:

            docker build -t wisecow-app .

   4. Test the Docker image locally:

            docker run -p 4499:4499 wisecow-app
         
# Kubernetes Deployment
   1. Create Deployment YAML (wisecow-deployment.yaml):
      
      *      apiVersion: apps/v1
             kind: Deployment
             metadata:
               name: wisecow-deployment
               labels:
                 app: wisecow
             spec:
               replicas: 1
               selector:
                 matchLabels:
                   app: wisecow
             template:
               metadata:
                 labels:
                   app: wisecow
             spec:
               containers:
               - name: wisecow
                 image: ${{ secrets.REGISTRY_USERNAME }}/wisecow-app:latest
                 ports:
                 - containerPort: 4499
      
   2. Create Service YAML (wisecow-service.yaml):
      
      *       apiVersion: v1
              kind: Service
              metadata:
                name: wisecow-service
              spec:
                selector:
                  app: wisecow
                ports:
                - protocol: TCP
                  port: 80
                  targetPort: 4499
                type: LoadBalancer

   3. Apply the manifest files:

      *         kubectl apply -f wisecow-deployment.yaml
                kubectl apply -f wisecow-service.yaml

# Continuous Integration and Deployment (CI/CD)

   1. GitHub Actions Workflow:

   * Create .github/workflows/ci-cd.yml:
     
            name: End to End CI/CD workflow
            on:
              push:
                branches:
                  - main
  
            jobs:
              build:
                runs-on: ubuntu-latest

                steps:
                - name: Checkout code
                  uses: actions/checkout@v3

                - name: Set up Docker Buildx
                  uses: docker/setup-buildx-action@v2

                - name: Log in to Docker Hub
                  uses: docker/login-action@v2
                  with:
                    username: ${{ secrets.REGISTRY_USERNAME }}
                    password: ${{ secrets.REGISTRY_PASSWORD }}

                - name: Build Docker image
                  run: docker build -t ${{ secrets.REGISTRY_USERNAME }}/wisecow-app .

                - name: Push Docker image
                  run: docker push ${{ secrets.REGISTRY_USERNAME }}/wisecow-app:latest
      
                - name: Deploy to Kubernetes
                  run: |
                    kubectl apply -f wisecow-deployment.yml
                    kubectl apply -f wisecow-service.yml
                  env:
                    KUBECONFIG: ${{ secrets.KUBE_CONFIG }}
   * Configure Docker and Kubernetes secrets in the GitHub repository settings.
# TLS Implementation
1. Generate TLS Certificates:
   * Use tools like Let's Encrypt to generate certificates.
2. Configure TLS in Kubernetes Ingress:
   * Create an Ingress resource for TLS termination.
   * Update wisecow-service.yaml to use NodePort or ClusterIP type.
   * Configure Ingress rules for secure communication.
