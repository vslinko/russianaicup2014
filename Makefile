all: test run

local-runner.zip:
	wget http://russianaicup.ru/s/1410298454962/assets/local-runner/local-runner.zip

local-runner: local-runner.zip
	mkdir local-runner
	cd local-runner; unzip ../local-runner.zip
	chmod a+x local-runner/*.sh

python3-cgdk.zip:
	wget http://russianaicup.ru/s/1410298454962/assets/cgdks/python3-cgdk.zip

python3-cgdk: python3-cgdk.zip
	unzip python3-cgdk.zip

src/model: python3-cgdk
	cp -r python3-cgdk/model src

src/RemoteProcessClient.py: python3-cgdk
	cp python3-cgdk/RemoteProcessClient.py src

src/Runner.py: python3-cgdk
	cp python3-cgdk/Runner.py src

prepare: local-runner src/model src/RemoteProcessClient.py src/Runner.py

test: prepare
	pep8 --exclude=src/astar.py,src/RemoteProcessClient.py,src/Runner.py src/*.py

run: prepare
	cd local-runner; ./local-runner.sh
	sleep 3
	python3 src/Runner.py

build.zip: test
	rm -rf build.zip
	cd src; zip -9 build.zip *.py -x RemoteProcessClient.py -x Runner.py
	mv src/build.zip build.zip

clean:
	rm -rf src/model src/RemoteProcessClient.py src/Runner.py
	rm -rf python3-cgdk.zip python3-cgdk
	rm -rf local-runner.zip local-runner

.PHONY: all prepare test run clean
