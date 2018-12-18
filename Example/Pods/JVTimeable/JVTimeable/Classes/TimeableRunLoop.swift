/// The current runLoops that a timer object can use.
public enum TimeableRunloop {
    case
    
    // The main runLoop.
    // This is used alot across StackOverflow answers.
    // Personally, I have no idea why this even should be used.
    // This is because it will not fire in the background.
    main,
    
    // The normal runLoop.
    // Use this when a timer can be invoked from the background thread.
    // I prefer this one over the main one.
    normal,
    
    // Ah, the unfamous commonModesRunLoop.
    // This is the most accurate runLoop since it will continue to time even if the user scrolls in UIScrollView.
    // This is not the case with the main/normal runLoop.
    commonModes
}
