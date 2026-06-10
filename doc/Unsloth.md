# Unsloth

Fine-tuning and inference framework for LLMs. Up to 2x faster training with less VRAM. Two modes: **Studio** (web UI) and **Core** (code/Python).

## Install

```bash
# macOS / Linux / WSL
curl -fsSL https://unsloth.ai/install.sh | sh

# Windows
irm https://unsloth.ai/install.ps1 | iex
```

Core (Python only, requires PyTorch):
```bash
uv pip install unsloth --torch-backend=auto
```

## Launch Studio

```bash
unsloth studio              # localhost only
unsloth studio -p 8888 -H 0.0.0.0   # expose to network
```

## Update Studio

```bash
unsloth studio update
```

## Find Models

- **Unsloth HuggingFace org:** https://huggingface.co/unsloth (1 300+ models)
- Filter by model family (Llama, Qwen, Gemma, Mistral, ...) or format (GGUF, LoRA, safetensors)
- Studio has a built-in search/download UI

### Naming convention

```
unsloth/<base>-<params>[-variant][-it]-GGUF
# e.g. unsloth/Llama-3.1-8B-Instruct-GGUF
#      unsloth/Qwen3.5-32B-A3B-it-GGUF
```

| Part | Meaning |
|------|---------|
| `-it` | instruction-tuned |
| `-GGUF` | quantised for local inference |
| `A3B`, `A4B` | active-parameter count (MoE models) |

## Load a Model (Core / Python)

```python
from unsloth import FastLanguageModel

model, tokenizer = FastLanguageModel.from_pretrained(
    model_name="unsloth/Llama-3.1-8B-Instruct",
    max_seq_length=4096,
    load_in_4bit=True,   # reduce VRAM
)
```

Pass any HuggingFace model ID or local path to `model_name`.

## Add a Custom / External Model

1. In Studio: search bar → paste a HuggingFace model ID → Download.
2. In Core: pass the HuggingFace ID or a local directory path to `from_pretrained`.

## Fine-tune (LoRA / QLoRA)

```python
model = FastLanguageModel.get_peft_model(
    model,
    r=16,               # LoRA rank
    lora_alpha=16,
    target_modules=["q_proj", "v_proj"],
)
# Then use HuggingFace Trainer or TRL's SFTTrainer as normal
```

Export when done:
```python
model.save_pretrained_gguf("model_gguf", tokenizer, quantization_method="q4_k_m")
```

## Docs & Notebooks

- Docs: https://unsloth.ai/docs
- Notebooks (Colab / Kaggle): linked from the GitHub README — cover Llama, Qwen, Gemma, Mistral, and more
