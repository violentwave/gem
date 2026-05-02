# Hardware Upgrade Assessment

## Current Hardware

| Component | Specification | Status |
|-----------|--------------|--------|
| GPU | NVIDIA GeForce GTX 1060 6GB | Functional but aging |
| RAM | ~16GB | Sufficient |
| Storage | Fedora Atomic image-based | Sufficient |
| CPU | Not specified | Sufficient for current load |

## GPU Limitations

### Current Constraints

- **VRAM:** 6GB limits model size to ~4B parameters
- **Architecture:** Pascal (older, no tensor cores)
- **CUDA:** Supported but not latest
- **Inference Speed:** Adequate for advisory tasks

### Impact on Operations

| Task | Current Performance | With Upgrade |
|------|-------------------|--------------|
| Gemma 4 inference | Fast | Faster |
| Larger models (7-8B) | Impossible | Possible |
| Embedding generation | Functional | Faster |
| Batch processing | Limited | Improved |
| Fine-tuning | Impossible | Possible (with 12GB+) |

## Upgrade Options

### Option 1: RTX 3060 12GB

| Aspect | Detail |
|--------|--------|
| VRAM | 12GB |
| Architecture | Ampere |
| Tensor Cores | Yes |
| Cost | ~$300-400 (used) |
| Benefit | Fits 7-8B models, faster inference |
| Recommendation | GOOD upgrade |

### Option 2: RTX 4060 Ti 16GB

| Aspect | Detail |
|--------|--------|
| VRAM | 16GB |
| Architecture | Ada Lovelace |
| Tensor Cores | Yes (4th gen) |
| Cost | ~$450-500 |
| Benefit | Fits 14B models (Phi-4), fastest inference |
| Recommendation | EXCELLENT upgrade |

### Option 3: RTX 3090 24GB

| Aspect | Detail |
|--------|--------|
| VRAM | 24GB |
| Architecture | Ampere |
| Tensor Cores | Yes |
| Cost | ~$800-1000 (used) |
| Benefit | Fits large models, future-proof |
| Recommendation | OVERKILL for current use case |

### Option 4: No Upgrade

| Aspect | Detail |
|--------|--------|
| Cost | $0 |
| Benefit | No disruption |
| Limitation | Stuck with 4B models |
| Recommendation | ACCEPTABLE (current use case is served) |

## Cost-Benefit Analysis

| Upgrade | Cost | Benefit | ROI |
|---------|------|---------|-----|
| RTX 3060 12GB | $350 | 7-8B models, faster | GOOD |
| RTX 4060 Ti 16GB | $475 | 14B models, fastest | GOOD |
| RTX 3090 24GB | $900 | Large models | POOR (overkill) |
| No upgrade | $0 | Current capability | ACCEPTABLE |

## Recommendation

**Current:** No upgrade needed. GTX 1060 6GB serves the current use case.

**If upgrading:** RTX 4060 Ti 16GB offers best future-proofing for reasonable cost.

**Timeline:** Not urgent. Can defer until:
- Gemma 4 capabilities become insufficient
- Need for larger models arises
- GPU fails or becomes unreliable
