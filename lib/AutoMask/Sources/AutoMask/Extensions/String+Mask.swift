//
//  Created by Felipe Hilst on 25/02/23.
//

import Foundation

private enum Constants : StringLiteralType {
    case maskRegexPattern = ##"(?<valid>#+)|(?<escaped>\\#)"##
    case validKeyWord = #"valid"#
    case escapePattern = ##"\#"##
    case basePattern = #"#"#
    case escapeChar = #"\"#
}

extension String {

    mutating public func apply(mask: String) -> String {

        var output = mask
        var input = self

        let matches = regexMatches(in: mask)

        let valids = filter(matches: matches)
        let spacesUsed = calculateTotalChars(matches: valids)

        guard input.count >= spacesUsed else { return input }

        valids.forEach { match in
            let matchRangeOnMask = match.range // get the range of the match
            guard let replaceSubStringRange = Range(matchRangeOnMask, in: output) else { return } // get the equivalent range in the output
            output.replaceSubrange(replaceSubStringRange, with: input[0..<matchRangeOnMask.length]) // replace in the output the first range of the input
            input = String(input.dropFirst(matchRangeOnMask.length)) // drop the input items used
        }

        output.replaceEscaped()

        return output
    }

    internal func regexMatches(in pattern: String, for regex: String = Constants.maskRegexPattern.rawValue) -> [NSTextCheckingResult] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let fullRange = NSRange(pattern.startIndex..., in: pattern)
            return regex.matches(in: pattern, range: fullRange)

        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }

    internal func filter(matches: [NSTextCheckingResult] , by key: StringLiteralType = Constants.validKeyWord.rawValue) -> [NSTextCheckingResult] {
        matches.filter { match in
            match.range(withName: key).length > 0
        }
    }

    private func calculateTotalChars(matches: [NSTextCheckingResult]) -> Int {
        matches.reduce(0, { (partial, match) in
            partial + match.range.length
        })
    }

    private mutating func replaceEscaped() {
        if #available(macOS 13.0, iOS 16.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *) {
            self.replace(Constants.escapePattern.rawValue, with: Constants.basePattern.rawValue)
        } else {
            let escapeChar = Character(Constants.escapeChar.rawValue)
            let emptyChar = Character("")
            self = String(self.map { $0 == escapeChar ? emptyChar : $0 })
        }
    }
}
