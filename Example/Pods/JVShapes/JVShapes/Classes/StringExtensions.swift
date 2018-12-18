public extension String {
    var contentTypeColorChanger: ContentTypeColorChanger {
        get {
            return ContentTypeColorChanger.getContentType(contentTypeId: self)
        }
    }
    
    var contentTypeShape: ContentTypeShape {
        get {
            return ContentTypeShape.getContentType(contentTypeId: self)
        }
    }
    
    var contentTypeShapeSpawner: ContentTypeShapeSpawner {
        get {
            return ContentTypeShapeSpawner.getContentType(contentTypeId: self)
        }
    }
    
    var contentTypeShapeStar: ContentTypeShapeStar {
        get {
            return ContentTypeShapeStar.getContentType(contentTypeId: self)
        }
    }
    
    var contentTypeShapes: [ContentTypeShape] {
        get {
            return ContentTypeShape.getContentTypes(contentTypeGroupId: self)
        }
    }
    
}
