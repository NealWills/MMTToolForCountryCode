import Foundation

class MMTToolForCountryCode: NSObject {

    public class func find(key: String) -> MMTToolForCountryIsoInfo? {
        return MMTToolForCountrys.allCountries.first {
            $0.alpha2 == key.uppercased() ||
            $0.alpha3 == key.uppercased() ||
            $0.numeric == key
        }
    }

    public class func searchByName(_ name: String) -> MMTToolForCountryIsoInfo? {
        let options: String.CompareOptions = [.diacriticInsensitive, .caseInsensitive]
        let name = name.folding(options: options, locale: .current)
        let countries = MMTToolForCountrys.allCountries.filter({
            $0.name.folding(options: options, locale: .current) == name
        })
        // If we cannot find a full name match, try a partial match
        return countries.count == 1 ? countries.first : searchByPartialName(name)
    }

    private class func searchByPartialName(_ name: String) -> MMTToolForCountryIsoInfo? {
        guard name.count > 3 else {
            return nil
        }
        let options: String.CompareOptions = [.diacriticInsensitive, .caseInsensitive]
        let name = name.folding(options: options, locale: .current)
        let countries = MMTToolForCountrys.allCountries.filter({
            $0.name.folding(options: options, locale: .current).contains(name)
        })
        // It is possible that the results are ambiguous, in that case return nothing
        // (e.g., there are two Koreas and two Congos)
        guard countries.count == 1 else {
            return nil
        }
        return countries.first
    }

    public class func searchByNumeric(_ numeric: String) -> MMTToolForCountryIsoInfo? {
        return MMTToolForCountrys.allCountries.first {
            $0.numeric == numeric
        }
    }

    public class func searchByCurrency(_ currency: String) -> [MMTToolForCountryIsoInfo] {
        let countries = MMTToolForCountrys.allCountries.filter({ $0.currency == currency })
        return countries
    }

    public class func searchByCallingCode(_ calllingCode: String) -> [MMTToolForCountryIsoInfo] {
        let countries = MMTToolForCountrys.allCountries.filter({ $0.calling == calllingCode })
        return countries
    }

}