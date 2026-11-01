"""Summarize go test -json while retaining failures and explicit skip counts."""
import collections
import json
import sys


def summarize(events):
    """Count terminal events once; package passes are separate from test passes."""
    tests, packages = {}, {}
    output = collections.defaultdict(list)
    for event in events:
        package = event.get("Package", "")
        if event.get("Output"):
            output[package].append(event["Output"])
        action = event.get("Action")
        if action in ("pass", "fail", "skip"):
            if event.get("Test"):
                tests[package, event["Test"]] = action
            else:
                packages[package] = action
    counts = collections.Counter(tests.values())
    failures = [name for name, status in packages.items() if status == "fail"]
    details = "".join("".join(output[name]) for name in failures)
    message = (f"Go tests/subtests: passed={counts['pass']} "
               f"failed={counts['fail']} skipped={counts['skip']}; "
               f"packages passed={list(packages.values()).count('pass')} "
               f"failed={len(failures)}")
    return message, details, bool(failures or counts["fail"])


if __name__ == "__main__":
    with open(sys.argv[1], encoding="utf-8-sig") as log:
        message, details, failed = summarize(json.loads(line) for line in log if line.strip())
    print(details, end="")
    print(message)
    sys.exit(1 if failed else 0)
