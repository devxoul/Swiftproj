@all: clean build install

clean:
	rm -f swiftproj-*.gem

build:
	gem build swiftproj.gemspec

install:
	gem install swiftproj-*.gem

push: clean build
	gem push swiftproj-*.gem
