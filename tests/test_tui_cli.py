import unittest
import subprocess
import tempfile
from pathlib import Path

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

class TestTuiIntentRouter(unittest.TestCase):
    def setUp(self):
        import importlib.machinery
        import importlib.util
        loader = importlib.machinery.SourceFileLoader("gemma_ui_tui_router", "bin/gemma-ui-tui")
        spec = importlib.util.spec_from_loader(loader.name, loader)
        self.tui = importlib.util.module_from_spec(spec)
        loader.exec_module(self.tui)

    def assertIntent(self, text, expected):
        routed = self.tui.route_chat_intent(text)
        self.assertEqual(routed["intent"], expected)
        self.assertIn("confidence", routed)
        self.assertIn("action", routed)
        self.assertIn("reason", routed)

    def test_route_memory_auto(self):
        self.assertIntent("what did we decide about ruvector", "memory_auto")

    def test_route_reports_latest(self):
        self.assertIntent("show latest report", "reports_latest")

    def test_route_reports_list(self):
        self.assertIntent("list reports", "reports_list")

    def test_route_dashboard(self):
        self.assertIntent("dashboard", "dashboard")

    def test_route_security_confirm_required(self):
        self.assertIntent("check firewall", "security_confirm_required")

    def test_route_general_chat(self):
        self.assertIntent("hello how are you", "general_chat")

    def test_normalize_reports_latest(self):
        self.assertEqual(self.tui.normalize_plain_command("reports latest"), "/reports latest")
        self.assertIsNone(self.tui.normalize_plain_command("latest reports"))

    def test_normalize_dashboard(self):
        self.assertEqual(self.tui.normalize_plain_command("status"), "/dashboard")

    def test_normalize_memory_search(self):
        self.assertEqual(
            self.tui.normalize_plain_command("memory search ruvector policy"),
            "/memory search ruvector policy",
        )

    def test_do_not_normalize_uncertain_phrase(self):
        self.assertIsNone(self.tui.normalize_plain_command("tell me about reports"))

    def test_compact_memory_panel_hides_raw_output(self):
        raw = "\n".join([
            "ruvector_top_sources: FINAL_POLICY.md (policy), RUNBOOK.md (operational)",
            "stage3a_top_sources: chunks.jsonl (stage3a)",
            "final_recommendation: use_ruvector_context",
            "RAW DETAIL SHOULD STAY DEBUG ONLY",
        ])
        panel = self.tui._compact_memory_panel(
            "what did we decide about ruvector",
            raw,
            "RuVector",
            "read-only semantic search",
        )
        joined = "\n".join(panel)
        self.assertIn("source family: RuVector", joined)
        self.assertIn("top sources: FINAL_POLICY.md, RUNBOOK.md", joined)
        self.assertNotIn("RAW DETAIL", joined)

    def test_compact_memory_panel_parses_markdown_source_labels(self):
        raw = "\n".join([
            "**RuVector Sources:** FINAL_POLICY.md, OPENCODE_GEMMA_NOTES.md",
            "**Stage 3A Sources:** chunks.jsonl",
            "Fallback status: `stage3a_available_as_comparison_baseline`",
        ])
        panel = self.tui._compact_memory_panel("ruvector status", raw, "RuVector + Stage 3A", "fallback")
        joined = "\n".join(panel)
        self.assertIn("source family: fallback", joined)
        self.assertIn("FINAL_POLICY.md", joined)

class TestTuiReportCards(unittest.TestCase):
    def setUp(self):
        import importlib.machinery
        import importlib.util
        loader = importlib.machinery.SourceFileLoader("gemma_ui_tui_reports", "bin/gemma-ui-tui")
        spec = importlib.util.spec_from_loader(loader.name, loader)
        self.tui = importlib.util.module_from_spec(spec)
        loader.exec_module(self.tui)

    def test_report_excerpt_is_compact(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "report.md"
            path.write_text("# Report\n\n" + "A long line. " * 80, encoding="utf-8")
            excerpt = self.tui._report_excerpt(path, max_chars=120)
            self.assertLessEqual(len(excerpt), 120)
            self.assertIn("Report", excerpt)

    def test_report_cards_include_metadata_and_preview(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "report.md"
            path.write_text("# Report\nPreview text", encoding="utf-8")
            stat = path.stat()
            cards = self.tui._report_cards([(path, stat.st_mtime, stat.st_size)], include_preview=True, limit=1)
            joined = "\n".join(cards)
            self.assertIn("Report: report.md", joined)
            self.assertIn("modified:", joined)
            self.assertIn("size:", joined)
            self.assertIn("preview:", joined)

if __name__ == "__main__":
    unittest.main()
