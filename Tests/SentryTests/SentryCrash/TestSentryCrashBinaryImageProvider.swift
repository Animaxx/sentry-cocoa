import Foundation

@objc
public class TestSentryCrashBinaryImageProvider: NSObject, SentryCrashBinaryImageProvider {
    
    var binaryImage: [SentryCrashBinaryImage] = []
    public func getBinaryImage(_ index: Int32) -> SentryCrashBinaryImage {
        binaryImage[Int(index)]
    }
    
    var imageCount = UInt(0)
    public func getImageCount() -> UInt {
        imageCount
    }
}
