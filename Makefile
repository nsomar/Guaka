test:
	xcodebuild -project Guaka.xcodeproj -scheme Guaka build test

coverage:
	slather coverage Guaka.xcodeproj