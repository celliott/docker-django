# docker-django makefile

TENNANT := demo
DATABASE := ${TENNANT}_stringer

PORTS = -p 5000:5000
ENVS = -e TENNANT=$(TENNANT) -e DATABASE=$(DATABASE)

VOLUMES = 
CONTAINER = django

.PHONY: container run

clean :
	rm -rf build

prep :
	rm -rf build && mkdir -p build
	git clone https://github.com/technivore/django-hello-world build
	echo "Flask\ngunicorn\nrequests\nvirtualenv\nvirtualenvwrapper" >> build/requirements.txt

container : prep
	docker build -t $(CONTAINER) .

run :
	docker run --restart=always --name $(CONTAINER) -i -d $(PORTS) $(ENVS) $(VOLUMES) -t $(CONTAINER)

stop :
	docker stop $(CONTAINER)
	docker rm $(CONTAINER)

kill :
	docker kill $(CONTAINER)
	docker rm $(CONTAINER)

restart :
	docker kill $(CONTAINER)
	docker rm $(CONTAINER)
	docker run --restart=always --name $(CONTAINER) -i -d $(PORTS) $(ENVS) $(VOLUMES) -t $(CONTAINER)

attach:
	docker attach $(CONTAINER)

tail:
	docker logs -f $(CONTAINER)
