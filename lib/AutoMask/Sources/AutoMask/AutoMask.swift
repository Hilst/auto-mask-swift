public struct AutoMask {

    private init() { /* NOT REACHEABLE */ }

    public static func apply(into subject: String, with mask: String) -> String {
        var input = subject
        return input.apply(mask: mask)
    }

}
