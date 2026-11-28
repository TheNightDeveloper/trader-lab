// Package fillpolicy holds the causal timing rules shared by the simulator and
// hypothetical training fills.
package fillpolicy

import "time"

const DefaultLatencyBars = 1

// DefaultTTL gives a causal next-open intent time to survive normal publication delay.
func DefaultTTL(latency int, frame time.Duration) time.Duration {
	return time.Duration(latency+9) * frame
}

// AllowsOpen includes both endpoints of the intent's execution window.
func AllowsOpen(open, decision, until time.Time) bool {
	return !open.Before(decision) && !open.After(until)
}
