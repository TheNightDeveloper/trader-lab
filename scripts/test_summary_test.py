"""Checks for CI evidence accounting; no third-party runtime needed."""
import unittest

from test_summary import summarize


class SummaryTest(unittest.TestCase):
    def test_skip_is_not_a_pass_and_failure_output_survives(self):
        message, details, failed = summarize([
            {"Package": "db", "Test": "connection", "Action": "skip"},
            {"Package": "db", "Action": "pass"},
            {"Package": "sim", "Test": "fill", "Action": "pass"},
            {"Package": "sim", "Output": "wrong price\n", "Action": "output"},
            {"Package": "sim", "Test": "other", "Action": "fail"},
            {"Package": "sim", "Action": "fail"},
        ])
        self.assertIn("passed=1 failed=1 skipped=1", message)
        self.assertEqual(details, "wrong price\n")
        self.assertTrue(failed)

    def test_passing_packages_are_not_extra_tests(self):
        message, _, failed = summarize([
            {"Package": "sim", "Test": "fill", "Action": "pass"},
            {"Package": "sim", "Action": "pass"},
        ])
        self.assertIn("passed=1 failed=0 skipped=0", message)
        self.assertFalse(failed)


if __name__ == "__main__":
    unittest.main()
