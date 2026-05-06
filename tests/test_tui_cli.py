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

    def test_tui_version(self):
        result = subprocess.run(["python3", "bin/gemma-ui-tui", "--version"], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0)
        self.assertIn("gemma-ui-tui v", result.stdout)

class TestTuiFormatting(unittest.TestCase):
    def setUp(self):
        import importlib.machinery
        import importlib.util
        loader = importlib.machinery.SourceFileLoader("gemma_ui_tui", "bin/gemma-ui-tui")
        spec = importlib.util.spec_from_loader(loader.name, loader)
        self.tui = importlib.util.module_from_spec(spec)
        loader.exec_module(self.tui)

    def test_wrap_lines_bullets(self):
        text = "- Bullet point\n  - Sub point"
        wrapped = self.tui._wrap_lines(text, prefix="│ Gemma: ", width=40)
        self.assertTrue(len(wrapped) >= 2)
        self.assertTrue(wrapped[0].startswith("│ Gemma: - Bullet point"))
        self.assertTrue(wrapped[1].startswith("│          - Sub point"))

    def test_wrap_lines_blank(self):
        text = "Hello\n\nWorld"
        wrapped = self.tui._wrap_lines(text, prefix="│ ", width=40)
        self.assertEqual(len(wrapped), 3)
        self.assertEqual(wrapped[0], "│ Hello")
        self.assertEqual(wrapped[1], "│")
        self.assertEqual(wrapped[2], "│ World")

if __name__ == "__main__":
    unittest.main()
