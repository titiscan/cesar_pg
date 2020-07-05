import Foundation

enum CesarError:Error {
    case badKey(Int)
}

struct Cesar {
    private var _key:Int
    private var _uppercase:Bool
    private var _printableCharacters = [ Character ]()
    private let ASCII_UPPERCASE_START = 65
    private let ASCII_UPPERCASE_END = 65+26
    private let ASCII_PRINTABLE_START = 32
    private let ASCII_PRINTABLE_END = 126
    
    
    init(_ key:Int, allAscii all:Bool = false) throws {
        _key = key
        _uppercase = !all
        genereratePrintableCharacter()
        
        if _key % _printableCharacters.count == 0 {
            throw CesarError.badKey(_printableCharacters.count)
        }
    }
    
    private mutating func genereratePrintableCharacter(){
        if _uppercase {
            for c in ASCII_UPPERCASE_START..<(ASCII_UPPERCASE_END) {
                _printableCharacters.append(Character(Unicode.Scalar(c)!))
            }
            _printableCharacters.append(contentsOf: " ")
            _printableCharacters.append(contentsOf: ",")
            _printableCharacters.append(contentsOf: ";")
            _printableCharacters.append(contentsOf: ".")
        }
        else {
            for c in ASCII_PRINTABLE_START ... ASCII_PRINTABLE_END {
                _printableCharacters.append(Character(Unicode.Scalar(c)!))
            }
        }
    }
    
    private func convertLetter(letter:Character, withKey key:Int) -> Character {
        
        if  let letterPosition = _printableCharacters.firstIndex(of: letter)
        {
            var newPosition = (letterPosition + key) % _printableCharacters.count
            if newPosition < 0 { newPosition += _printableCharacters.count}
            return _printableCharacters[newPosition]
        }
        // not found in printable characters array
        let ERROR_CHAR = Character(Unicode.Scalar(UInt16(10007))!)
        
        if letter == ERROR_CHAR {
            return " "
        }
        print ("Charactère non trouvé : \(letter)")
        return ERROR_CHAR
    }
    
    private func prepareText(_ text:String) -> String {
        if _uppercase {
            return text.uppercased()
        }
        return text
    }
    
    func encode(_ text:String) -> String {
        var encodedString = ""

        for c in prepareText(text) {
            encodedString.append(convertLetter(letter: c, withKey: _key))
        }
        return encodedString
    }

    func decode(_ text:String) -> String {
        var decodedString = ""
        
        for c in text {
            decodedString.append(convertLetter(letter: c, withKey: -_key))
        }
        return decodedString
    }
}

// *************************************************

var str = "Hello, Playground."
let KEY = 5

do {
    let crypto = try Cesar(KEY,allAscii: false)
    
    let crypted = crypto.encode(str)
    print (crypted)
    let decrypted = crypto.decode(crypted)
    print (decrypted)

    
} catch CesarError.badKey(let nb) {
    print ("Veuillez choisir une clé qui ne soit pas un multiple de \(nb)")
}
