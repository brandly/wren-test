import "src/matchers/stub" for StubMatchers

// Create top-level class so that trying to access an undefined matcher doesn't
// result in leaking the implementation details of how our matcher classes are
// combined and create a potentially misleading error message:
//   Error: StubMatchers does not implement 'toBeUndefined'
// This error message is misleading because this isn't a problem with the
// StubMatchers class instead the real problem is that none of the base matcher
// classes define the 'toBeUndefined' matcher. Utilizing this empty class will
// result in a more correct (and useful) error message if the user is accessing
// an undefined matcher:
//   Error: Matchers does not implement 'toBeUndefinedMatcher'
class Matchers is StubMatchers {
  /**
   * Create a new `Matcher` object for a value.
   *
   * @param {*} value The value to be matched on.
   */
  construct new (value) {
    super(value)
  }
}

/**
 * Convenience method for creating new Matchers in a more readable style.
 *
 * @param {*} value Value to create a new matcher for.
 * @return A new `Matchers` instance for the given value.
 */
var Expect = Fn.new { |value|
  return Matchers.new(value)
}
