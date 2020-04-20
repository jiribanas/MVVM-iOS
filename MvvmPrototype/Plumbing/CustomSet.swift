import Foundation

struct CustomSet<T : Comparable & Hashable> {
    private var list: [T]
    init(_ list: [T]){
        let uniqueKeys = list.reduce(into: [:]){ dict, item in
            dict[item, default: 0] += 1
            }.keys
        self.list = Array(uniqueKeys)
    }
}

extension CustomSet : Equatable {
    static func == (lhs: CustomSet, rhs: CustomSet) -> Bool {
        return lhs.list.count == rhs.list.count && lhs.list.sorted() == rhs.list.sorted()
    }
}
