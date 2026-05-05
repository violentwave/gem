"""Lightweight rendering tests for gemma-ui.

Uses subprocess to verify CLI output without importing the script directly.
Run with: python3 -m unittest discover -s tests
"""

import subprocess
import sys
import unittest
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
GEMMA_UI = REPO_ROOT / "bin" / "gemma-ui"


class TestGemmaUiRendering(unittest.TestCase):
    """Verify gemma-ui CLI renders expected output."""

    def _run(self, *args):
        """Run gemma-ui with args and return (stdout, stderr, rc)."""
        cmd = [sys.executable, str(GEMMA_UI)] + list(args)
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=30,
        )
        return result.stdout, result.stderr, result.returncode

    # ── Exit code tests ──────────────────────────────────────────────────────

    def test_help_exits_zero(self):
        stdout, stderr, rc = self._run("--help")
        self.assertEqual(rc, 0, f"--help failed: {stderr}")

    def test_demo_layout_exits_zero(self):
        stdout, stderr, rc = self._run("--demo-layout")
        self.assertEqual(rc, 0, f"--demo-layout failed: {stderr}")

    def test_dashboard_exits_zero(self):
        stdout, stderr, rc = self._run("--dashboard")
        self.assertEqual(rc, 0, f"--dashboard failed: {stderr}")

    def test_version_exits_zero(self):
        stdout, stderr, rc = self._run("--version")
        self.assertEqual(rc, 0, f"--version failed: {stderr}")

    # ── Content tests ────────────────────────────────────────────────────────

    def test_demo_layout_contains_app_name(self):
        stdout, _, rc = self._run("--demo-layout")
        self.assertEqual(rc, 0)
        self.assertIn("Gemma", stdout)

    def test_demo_layout_contains_modes(self):
        stdout, _, rc = self._run("--demo-layout")
        self.assertEqual(rc, 0)
        # Mode rail should contain these hotkeys
        self.assertIn("[G]", stdout)
        self.assertIn("[S]", stdout)
        self.assertIn("[M]", stdout)
        self.assertIn("[V]", stdout)

    def test_demo_layout_contains_footer_commands(self):
        stdout, _, rc = self._run("--demo-layout")
        self.assertEqual(rc, 0)
        # Footer should show command shortcuts
        self.assertIn("[?]", stdout)
        self.assertIn("[/]", stdout)

    def test_help_contains_commands(self):
        stdout, _, rc = self._run("--help")
        self.assertEqual(rc, 0)
        self.assertIn("--demo-layout", stdout)
        self.assertIn("--help", stdout)
        # UI commands use / prefix
        self.assertIn("/dashboard", stdout)
        self.assertIn("/quit", stdout)

    def test_dashboard_contains_core(self):
        stdout, _, rc = self._run("--dashboard")
        self.assertEqual(rc, 0)
        # Dashboard should show core status items
        self.assertIn("Ollama", stdout)

    def test_version_contains_version_string(self):
        stdout, _, rc = self._run("--version")
        self.assertEqual(rc, 0)
        self.assertIn("gemma-ui", stdout)
        # Should contain a version like 1.5.x
        import re
        self.assertRegex(stdout, r"gemma-ui\s+\d+\.\d+\.\d+")

    def test_list_modes_exits_zero(self):
        stdout, stderr, rc = self._run("--list-modes")
        self.assertEqual(rc, 0, f"--list-modes failed: {stderr}")


if __name__ == "__main__":
    unittest.main()
