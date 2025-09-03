So#ware-Defined Systems
Ac#vity: Orchestra#ng microservices containers
1. Work individually. This assignment is due Wednesday October 3th, 2025 no later than
11:00 pm (23:00) on mycourseville (pdf only)
2. You will create docker-compose file to orchestrate the following components
a. todo-webapp (src=release-3.1) – map port: container 3000 to host 3000
b. todo (src=release-3) – set name to todo-service
c. todo-noJficaJon (src=release-1.1) – set name to noJficaJon-service
d. API Gateway (using NGINX) – map port: container 8000 to host 8000 – set name to
api-gateway
e. Network name: todo-net
3. Todo, todo-noJficaJon, API gateway must be all connected to the same internal network
4. You must modify nginx configuraJon file as followed
a. Listen to port 8000
b. Point proxy from /todo/ to hVp://todo-service:8000/
c. Point proxy from /noJficaJon/ to hVp://noJficaJon-service:9000/
5. Prepare a set of slides in PDF containing the following informaJon
a. Your docker-compose.yml
b. Screenshot when you run docker-compose up
c. Screenshot a[er all containers are running and you use command: docker ps –a
d. Screenshot of browser connecJng to todo-webapp with some todo items
YOU MUST ALSO USING GRADER (URL is in MCV’s assignment)