test_darwin:
	swift package generate-xcodeproj --enable-code-coverage
	xcodebuild -project Guaka.xcodeproj -scheme Guaka-Package build test

test_linux:
	docker run --volume `pwd`:`pwd` --workdir `pwd` swift:4.1.3 swift test

coverage:
	slather coverage Guaka.xcodeproj

generate:
	swift package generate-xcodeproj --enable-code-coverage

doc:
	rm -rf docs
	make generate

	jazzy \
  --author "The Guaka Authors" \
  --author_url https://getguaka.github.io \
  --github_url https://github.com/nsomar/Guaka/tree/master \
  --output docs \
  --xcodebuild-arguments -target,Guaka \
  --github-file-prefix https://github.com/nsomar/Guaka \
  --theme fullwidth

copy-docs:
	make doc
	cp -R docs/** ../getguaka.github.io/
