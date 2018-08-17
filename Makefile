test:
	swift test
	docker run --volume `pwd`:`pwd` --workdir `pwd` swift:4.1.3 swift test

coverage:
	slather coverage Guaka.xcodeproj

generate:
	swift package generate-xcodeproj --enable-code-coverage

doc:
	rm -rf docs
	make generate

	jazzy \
  --author "Omar Abdelhafith" \
  --author_url http://getguaka.com \
  --github_url https://github.com/nsomar/Guaka/tree/master \
  --output docs \
  --xcodebuild-arguments -scheme,Guaka \
  --github-file-prefix https://github.com/nsomar/Guaka \
  --theme fullwidth

copy-docs:
	make doc
	scp -r docs getGuaka:/var/www/guaka/help
