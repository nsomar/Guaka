test:
	xcodebuild -project Guaka.xcodeproj -scheme Guaka build test

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
  --github_url https://github.com/oarrabi/Guaka/tree/master \
  --output docs \
  --xcodebuild-arguments -scheme,Guaka \
  --github-file-prefix https://github.com/oarrabi/Guaka

copy-docs:
	make doc
	scp -r docs getGuaka:/var/blog/nsomar/Guaka/Help
