import Foundation
/**
 Validating auto mask for numbers

 number -> string -> masked string

 or

 string -> masked string

 base example:

 Brazillian doc CPF
 12345678900 + ###.###.###-## = 123.456.789-00

 Brazillian doc RG
 123456789 + ##.###.###-# = 12.345.678-9
 */

// MARK: - CONSTANTS / INPUTS

let type = "CPF"

var input: Int
var mask: String = "##.###.###-#"

switch type {
case "CPF":
    input = 12345678900
    mask = "###.###.###-##"
    break
case "RG":
    input = 123456789
    mask = "##.###.###-#"
default:
    input = 0
    mask = ""
}
let inputString: String = String(input)


// MARK: - REGEX APPLICATION
let pattern = ##"(?<valid>#+)|(?<escaped>\\#)"##
let regex = try NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
let matches = regex.matches(in: mask, range: NSRange(mask.startIndex..., in: mask))

// MARK: - VARIABLES
var output = mask
var variableInput = inputString

// MARK: - CALCULATED VARIABLES
let validMatches = matches.filter { $0.range(withName: "valid").length > 0 }
let spacesUsed = validMatches.reduce(0, { (partial, match) in return partial + match.range.length })

// MARK: - SIZE VALIDATIONS

let isValidComposition = inputString.count >= spacesUsed

// MARK: - LOOP
validMatches.forEach {
    let matchRangeOnMask = $0.range
    guard let stringSubstitutionRange = Range(matchRangeOnMask, in: output) else { return }
    output.replaceSubrange(stringSubstitutionRange, with: variableInput[0 ..< matchRangeOnMask.length])
    variableInput = String(variableInput.dropFirst(matchRangeOnMask.length))
}
output.replace("\\#", with: "#")
print(output)

// MARK: - EXTENSIONS RANGE HELP
extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}

