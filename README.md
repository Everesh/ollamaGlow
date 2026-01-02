# ollamaGlow

Minor tweaks to the default ollama client

[![asciicast](https://asciinema.org/a/5lZzakcuv3lqfLsAvbz9cjfGp.svg)](https://asciinema.org/a/5lZzakcuv3lqfLsAvbz9cjfGp)

- switching to alt buffer
- markdown post-processing
- output pagination
- full stdio passthrough
  - your CTRL+D and CTRL+C should still work
  - the generation stream should still be mirrored to the term as its going

## Requirements
- [ollama](https://ollama.com/)
- [glow](https://github.com/charmbracelet/glow)

## Usage
```shell
./ollamaGlow.sh <model>
```
if you don't specify a model, the script will default to `qwen3-coder:30b`
