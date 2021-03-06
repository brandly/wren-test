import "src/matchers" for Expect
import "src/stub" for Stub
import "src/suite" for Suite

import "src/expectation" for Expectation
import "src/matchers/stub" for StubMatchers
import "test/test-utils" for MatcherTestHarness

var TestStubMatchers = Suite.new("StubMatchers") { |it|
  it.suite("#toHaveBeenCalled") { |it|
    it.should("abort the fiber if the value given is not a stub") {
      var fiber = Fiber.new {
        var matcher = StubMatchers.new("not a stub")
        matcher.toHaveBeenCalled
      }

      fiber.try()

      Expect.call(fiber.isDone).toBeTrue
      Expect.call(fiber.error).toEqual("not a stub was not a Stub")
    }

    it.should("be false if the stub has not been called") {
      var stub = Stub.new("stub")

      var expectation = MatcherTestHarness.call {
        var matcher = StubMatchers.new(stub)
        matcher.toHaveBeenCalled
      }

      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeFalse
      Expect.call(expectation.message).toEqual(
          "Expected stub to have been called")
    }

    it.should("be true if the stub has been called at least once") {
      var stub = Stub.new("stub")
      stub.call

      var expectation = MatcherTestHarness.call {
        var matcher = StubMatchers.new(stub)
        matcher.toHaveBeenCalled
      }

      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeTrue
    }

    it.should("be false if stub was not called the right number of times") {
      var stub = Stub.new("stub")
      stub.call

      var expectation = MatcherTestHarness.call {
        var matcher = StubMatchers.new(stub)
        matcher.toHaveBeenCalled(2)
      }

      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeFalse
      Expect.call(expectation.message).toEqual(
          "Expected stub to have been called 2 times but was called 1 times")

      stub.call
      stub.call

      expectation = MatcherTestHarness.call {
        var matcher = StubMatchers.new(stub)
        matcher.toHaveBeenCalled(2)
      }

      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeFalse
      Expect.call(expectation.message).toEqual(
          "Expected stub to have been called 2 times but was called 3 times")
    }

    it.should("be true if the stub was called the right number of times") {
      var stub = Stub.new("stub")
      stub.call
      stub.call

      var expectation = MatcherTestHarness.call {
        var matcher = StubMatchers.new(stub)
        matcher.toHaveBeenCalled(2)
      }

      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeTrue
    }
  }

  it.suite("#toHaveBeenCalledWith") { |it|
    it.should("abort the fiber if the value given is not a stub") {
      var fiber = Fiber.new {
        var matcher = StubMatchers.new("not a stub")
        matcher.toHaveBeenCalledWith(1)
      }

      fiber.try()

      Expect.call(fiber.isDone).toBeTrue
      Expect.call(fiber.error).toEqual("not a stub was not a Stub")
    }

    it.should("be false if the stub was not called with the given args") {
      var stub = Stub.new("stub")
      stub.call(1)

      var expectation = MatcherTestHarness.call {
        var matcher = StubMatchers.new(stub)
        matcher.toHaveBeenCalledWith([2])
      }

      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeFalse
      Expect.call(expectation.message).toEqual("Expected stub to have been " +
          "called with [2] but was never called. Calls were:\n    [1]")
    }

    it.should("be true if the stub was called with the given args") {
      var stub = Stub.new("stub")
      stub.call(1)
      stub.call(2)
      stub.call(3, 4)

      var expectation = MatcherTestHarness.call {
        var matcher = StubMatchers.new(stub)
        matcher.toHaveBeenCalledWith([2])
      }

      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeTrue
    }

    it.should("return one Expectation if there are multiple matching calls") {
      var stub = Stub.new("stub")
      stub.call(1)
      stub.call(1)

      var fiber = Fiber.new {
        var matcher = StubMatchers.new(stub)
        matcher.toHaveBeenCalledWith([1])
      }
      var expectation = fiber.try()

      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeTrue

      // Ensure there was only one `Expectation` yielded by the matcher.
      Expect.call(fiber.try()).toBeNull
      Expect.call(fiber.isDone).toBeTrue
    }
  }
}
