public extension String {
    var contentTypeColorBlender: ContentTypeColorBlender {
        get {
            return ContentTypeColorBlender.getContentType(contentTypeId: self)
        }
    }
}
