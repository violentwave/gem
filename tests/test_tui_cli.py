import unittest
import subprocess
import os

class TestTuiCli(unittest.TestCase):
    def test_tui_check(self):
        result = subprocess.run(["python3", "bin/gemma-ui-tui", "--check"], capture_output=True, text=True)
        self.assertIn(result.returncode, [0, 1])
        self.assertIn("gemma-ui-tui check", result.stdout)

    def test_tui_help(self):
        result = subprocess.run(["python3", "bin/gemma-ui-tui", "--help"], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0)
        self.assertIn("--check", result.stdout)

    def test_ui_tui_check(self):
        result = subprocess.run(["python3", "bin/gemma-ui", "--tui-check"], capture_output=True, text=True)
        self.assertIn(result.returncode, [0, 1])

    def test_ui_help_contains_tui(self):
        result = subprocess.run(["python3", "bin/gemma-ui", "--help"], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0)
        self.assertIn("--tui", result.stdout)

    def test_compile_tui(self):
        result = subprocess.run(["python3", "-m", "py_compile", "bin/gemma-ui-tui"])
        self.assertEqual(result.returncode, 0)

    def test_compile_ui(self):
        result = subprocess.run(["python3", "-m", "py_compile", "bin/gemma-ui"])
        self.assertEqual(result.returncode, 0)

if __name__ == "__main__":
    unittest.main()
