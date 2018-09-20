import XCTest
@testable import GuakaTests


XCTMain([
    testCase(ArgTokenTypeTests.allTests),
    testCase(CommandExecutionTests.allTests),
    testCase(CommandHelpTests.allTests),
    testCase(CommandParsingTests.allTests),
    testCase(CommandTests.allTests),
    testCase(CommandRunTests.allTests),
    testCase(CommandTest.allTests),
    testCase(CustomFlagTypesTests.allTests),
    testCase(ErrorTests.allTests),
    testCase(FlagHelpTests.allTests),
    testCase(FlagSetTests.allTests),
    testCase(FlagsTests.allTests),
    testCase(FlagTests.allTests),
    testCase(HelpGeneratorSubclassingTests.allTests),
    testCase(HelpGeneratorTests.allTests),
    testCase(HelpTests.allTests),
    testCase(LevenshteinTests.allTests),
    testCase(ParsingTests.allTests),
    testCase(ValidationTests.allTests),
])
