public struct RandomProbability {
    public var probability: [Double]
    
    public init(probability: [Double]) {
        self.probability = probability
    }
    
    // Returns weighted random index
    public var random:  Int {
        get {
            return RandomProbability.randomNumber(probabilities: probability)
        }
    }
    
    public static func randomNumber(probabilities: [Double]) -> Int {
        let sum = probabilities.reduce(0, +)
        let rnd = sum * Double(arc4random_uniform(UInt32.max)) / Double(UInt32.max)
        var accum = 0.0
        for (i, p) in probabilities.enumerated() {
            accum += p
            if rnd < accum {
                return i
            }
        }
        return (probabilities.count - 1)
    }
}
