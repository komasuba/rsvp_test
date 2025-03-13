import Foundation
import NaturalLanguage

func tokenizeText(_ text: String) -> [String] {
    let tagger = NLTagger(tagSchemes: [.tokenType])
    tagger.string = text

    var tokens: [String] = []
    let options: NLTagger.Options = []

    tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .tokenType, options: options) { tag, tokenRange in
        let token = String(text[tokenRange])
        tokens.append(token)
        return true
    }
    return tokens
}
