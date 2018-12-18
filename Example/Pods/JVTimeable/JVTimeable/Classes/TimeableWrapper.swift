/// Standard class to use when creating timeable objects.
open class TimeableWrapper: Timeable {
    
    public var timer: Timer?
    open var timerIntervalSeconds: TimeInterval
    public var timeThatTheTimerStarted: TimeInterval = 0
    public var timeThatTheTimerHasBeenPaused: TimeInterval?
    public var timerHasFired: (() -> ())!
    public var continueTimingWhenPaused: Bool
    public let repeatTimerAfterCompletion: Bool
    public let runLoop: TimeableRunloop
    
    // timerHasFired isn't in the initializer because we want to use this later on with a [weak self] block
    // Which should be setted later. I think this isn't possible with an initializer
    public init(timerIntervalSeconds: TimeInterval, continueTimingWhenPaused: Bool, repeatTimerAfterCompletion: Bool, runLoop: TimeableRunloop) {
        self.timerIntervalSeconds = timerIntervalSeconds
        self.continueTimingWhenPaused = continueTimingWhenPaused
        self.repeatTimerAfterCompletion = repeatTimerAfterCompletion
        self.runLoop = runLoop
        
        // Assertion failure? You got the wrong class/runLoop.
        assert(runLoop == .commonModes ? self is TimeableWrapperCommonModes : !(self is TimeableWrapperCommonModes))
    }
    
    /// This method is here to easily override it by subclasses.
    /// See method pause() why we need to copy everything
    open func resume() {
        // Copied
        guard let timeThatTheTimerHasBeenPaused = timeThatTheTimerHasBeenPaused else {
            determineStartTimer(nil)
            return
        }
        
        let secondsForTheTimerToRun: TimeInterval
        
        if continueTimingWhenPaused {
            secondsForTheTimerToRun = timerIntervalSeconds - ((timeThatTheTimerHasBeenPaused + (Date.timeIntervalSinceReferenceDate - timeThatTheTimerHasBeenPaused)) - timeThatTheTimerStarted)
        } else {
            secondsForTheTimerToRun = timerIntervalSeconds - (timeThatTheTimerHasBeenPaused - timeThatTheTimerStarted)
        }
        
        if secondsForTheTimerToRun < 0 {
            timerHasFired()
            if repeatTimerAfterCompletion {
                determineStartTimer(nil)
            }
        } else {
            determineStartTimer(secondsForTheTimerToRun)
        }
    }
    
    // This method is here to easily override it by subclasses.
    // Because of the current situation, we really NEED TO COPY EVERYTHING.
    // You can't cast is as the protocol, because when a subclass of this class will override pause again, it will create an infinity loop.
    open func pause() {
        // Copied
        timeThatTheTimerHasBeenPaused = Date.timeIntervalSinceReferenceDate
        removeTimer()
    }
    
    deinit {
        removeTimer()
    }
    
}
