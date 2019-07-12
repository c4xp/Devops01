# docker login git:5000
# docker build . -t git:5000/path/demox:1.7.0 -f .php.dockerfile
# docker push git:5000/path/demox:1.7.0

# docker build . -t demox:1.0.0
# docker run -d -p 5000:5000 --restart=always --name registry registry:2
# docker tag demox:1.0.0 localhost:5000/demox
# docker push localhost:5000/demox
# kubectl run demox --image=demox:1.0.0 --image-pull-policy=Never

# https://matthewpalmer.net/kubernetes-app-developer/articles/php-fpm-nginx-kubernetes.html
# http://www.inanzzz.com/index.php/post/zpbw/creating-a-simple-php-fpm-nginx-and-mysql-application-with-docker-compose
# https://hub.docker.com/_/php/