import Foundation

class AppSettings: NSObject
{
    class var LastUsedCustomerAccountId: Int64?
    {
        set (newValue)
        {
            UserDefaults.standard.set(newValue, forKey: "LastUsedCustomerAccountId")
        }
        get
        {
            return UserDefaults.standard.object(forKey: "LastUsedCustomerAccountId") as? Int64
        }
    }
}
