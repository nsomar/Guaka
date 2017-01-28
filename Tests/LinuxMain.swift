import XCTest
@testable import GuakaTests


XCTMain([
     testCase(LevenshteinTests.allTests),
     testCase(CommandExecutionTests.allTests),
])
