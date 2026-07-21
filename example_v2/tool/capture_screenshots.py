#!/usr/bin/env python3
"""Capture AURA screenshots on a booted iOS Simulator via Quartz clicks + simctl."""

from __future__ import annotations

import subprocess
import time
from pathlib import Path

UDID = "1656724A-2D47-4F42-9AC4-DA71E3FBBAAF"
BUNDLE = "com.masterfabric.aura"
OUT = Path(__file__).resolve().parents[1] / "docs" / "screenshots"


def sh(*args: str, check: bool = True) -> subprocess.CompletedProcess:
    return subprocess.run(args, check=check, capture_output=True, text=True)


def screenshot(name: str) -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    path = OUT / f"{name}.png"
    sh("xcrun", "simctl", "io", UDID, "screenshot", str(path))
    print(f"saved {path} ({path.stat().st_size // 1024} KB)")


def open_url(url: str) -> None:
    sh("xcrun", "simctl", "openurl", UDID, url)


def terminate() -> None:
    sh("xcrun", "simctl", "terminate", UDID, BUNDLE, check=False)


def launch() -> None:
    sh("xcrun", "simctl", "launch", UDID, BUNDLE)


def uninstall() -> None:
    sh("xcrun", "simctl", "uninstall", UDID, BUNDLE, check=False)


def click_norm(nx: float, ny: float) -> None:
    """Click normalized coords (0–1) inside the front Simulator device frame."""
    script = f"""
    tell application "Simulator" to activate
    delay 0.25
    tell application "System Events"
      tell process "Simulator"
        set win to front window
        set {{x, y}} to position of win
        set {{w, h}} to size of win
        -- approximate chrome: title bar ~28pt, sides ~0
        set contentY to y + 52
        set contentH to h - 72
        set clickX to x + (w * {nx})
        set clickY to contentY + (contentH * {ny})
      end tell
    end tell
    do shell script "/usr/bin/python3 - <<'PY'\\n" & ¬
      "import Quartz\\n" & ¬
      "x=float(" & (clickX as string) & "); y=float(" & (clickY as string) & ")\\n" & ¬
      "Quartz.CGEventPost(Quartz.kCGHIDEventTap, Quartz.CGEventCreateMouseEvent(None, Quartz.kCGEventLeftMouseDown, (x,y), Quartz.kCGMouseButtonLeft))\\n" & ¬
      "Quartz.CGEventPost(Quartz.kCGHIDEventTap, Quartz.CGEventCreateMouseEvent(None, Quartz.kCGEventLeftMouseUp, (x,y), Quartz.kCGMouseButtonLeft))\\n" & ¬
      "PY"
    """
    # Simpler: use cliclick-like via osascript click at position — System Events click
    script2 = f"""
    tell application "Simulator" to activate
    delay 0.2
    tell application "System Events"
      tell process "Simulator"
        set win to front window
        set {{px, py}} to position of win
        set {{pw, ph}} to size of win
      end tell
    end tell
    set cx to px + (pw * {nx})
    set cy to py + 48 + ((ph - 70) * {ny})
    do shell script "python3 -c \\"import Quartz; x=" & cx & "; y=" & cy & "; Quartz.CGEventPost(Quartz.kCGHIDEventTap, Quartz.CGEventCreateMouseEvent(None, Quartz.kCGEventLeftMouseDown, (x,y), 0)); Quartz.CGEventPost(Quartz.kCGHIDEventTap, Quartz.CGEventCreateMouseEvent(None, Quartz.kCGEventLeftMouseUp, (x,y), 0))\\""
    """
    subprocess.run(["osascript", "-e", script2], check=False)


def wait(sec: float) -> None:
    time.sleep(sec)


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)

    # Fresh install assumed already done by outer shell; just relaunch clean.
    terminate()
    wait(0.5)
    launch()
    wait(4.5)
    screenshot("01_splash_or_onboarding_welcome")

    # Onboarding: Continue (bottom)
    click_norm(0.72, 0.93)
    wait(1.2)
    screenshot("02_onboarding_sex")

    # Pick Woman (left card-ish)
    click_norm(0.28, 0.55)
    wait(0.8)
    screenshot("03_onboarding_sex_selected")
    click_norm(0.72, 0.93)
    wait(1.2)
    screenshot("04_onboarding_body_name")

    # Skip typing name — tap Continue may toast; tap name field and type via paste
    click_norm(0.50, 0.42)
    wait(0.4)
    subprocess.run(
        ["osascript", "-e", 'tell application "System Events" to keystroke "AURA"'],
        check=False,
    )
    wait(0.4)
    click_norm(0.72, 0.93)
    wait(1.2)
    screenshot("05_onboarding_activity")
    click_norm(0.72, 0.93)
    wait(1.2)
    screenshot("06_onboarding_goal")
    click_norm(0.72, 0.93)
    wait(1.2)
    screenshot("07_onboarding_ready")
    click_norm(0.72, 0.93)
    wait(1.8)
    screenshot("08_permissions_intro")

    # Permissions: Continue / Not now through steps
    for i, name in enumerate(
        [
            "09_permissions_notifications",
            "10_permissions_location",
            "11_permissions_fitness",
            "12_permissions_ready",
        ],
        start=1,
    ):
        click_norm(0.72, 0.93)  # Continue / primary
        wait(1.3)
        # Prefer Not now on permission prompts if a secondary sits left
        if i <= 3:
            click_norm(0.28, 0.93)
            wait(0.8)
        screenshot(name)

    click_norm(0.72, 0.93)
    wait(2.0)
    screenshot("13_today")

    open_url("aura://log")
    wait(1.5)
    screenshot("14_log")

    open_url("aura://body")
    wait(1.5)
    screenshot("15_body")

    open_url("aura://coach")
    wait(1.5)
    screenshot("16_coach")

    open_url("aura://today")
    wait(1.2)
    # Profile avatar top-right-ish on Today
    click_norm(0.90, 0.12)
    wait(1.2)
    screenshot("17_profile_sheet")

    print("done:", OUT)


if __name__ == "__main__":
    main()
