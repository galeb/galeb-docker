GALEB_VERSION ?= 4.0.0
RPM_VER=$(GALEB_VERSION)
VERSION=${RPM_VER}
RELEASE=$(shell date +%Y%m%d%H%M)
SERVICES=router legba kratos api health

setup:
	git pull --recurse-submodules
	git submodule update --remote --recursive

common: clean
	GALEB_VERSION=${GALEB_VERSION} ./mvnw -f galeb/core/pom/xml install -DskipTests
	GALEB_VERSION=${GALEB_VERSION} ./mvnw -f galeb/newcore/pom/xml install -DskipTests

package: common
	GALEB_VERSION=${GALEB_VERSION} ./mvnw -f galeb.pom.xml package -DskipTests

test: clean
	GALEB_VERSION=${GALEB_VERSION} ./mvnw -f galeb/pom.xml test

clean: setup
	GALEB_VERSION=${GALEB_VERSION} ./mvnw -f galeb/pom.xml clean
	rm -vf galeb/dists/galeb-$$service-${RPM_VER}*.rpm

run:
	docker-compose up -d

stop:
	docker-compose stop -t1
	docker-compose rm -f
	docker network prune -f

volume-prune:
	docker volume prune -f

