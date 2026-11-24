---
name: jupyter-collab
description: Set up a uv-managed JupyterLab environment and edit .ipynb notebooks directly with Jupyter Collaboration while preserving cell IDs, outputs, and the user's open session.
---

# Jupyter collaboration

## Environment

Inspect the existing project, notebook setup, and running servers first. Reuse the environment and server where possible. Use `uv`; initialize with `uv init --bare` only when no `pyproject.toml` exists. Add missing dependencies as needed:

```bash
export UV_CACHE_DIR=/tmp/jupyter-collab-uv-cache
export JUPYTER_DATA_DIR=/tmp/jupyter-collab-data
uv add jupyterlab jupyter-collaboration nbformat ipykernel
uv run jupyter lab --no-browser
```

Use the writable `UV_CACHE_DIR` for uv commands. Set `JUPYTER_DATA_DIR` for the Jupyter server and notebook trust/signature operations; plain `nbformat.read/write` does not need it. Install analysis packages according to the project. Installing extensions may require restarting the server.

## Editing

Edit `.ipynb` directly with `nbformat`:

1. Read the existing notebook with `nbformat.read(..., as_version=4)`. Record its file modification time in nanoseconds and size (`st_mtime_ns`, `st_size`). Display only the cell summaries and relevant sources needed for the task.
2. Identify cells by ID and edit their `source`. Preserve IDs, outputs, execution counts, attachments, and cell and notebook metadata unless the requested change requires modifying them. When inserting, deleting, or reordering, retain existing cell objects and give new cells unique IDs.
3. Immediately before saving, compare the current file modification time and size with the recorded values. If unchanged, save without rereading. If changed, reread programmatically and surface only affected cells or a compact diff in context. Apply the edits to the latest notebook, preserving unrelated concurrent changes and resolving overlapping edits.
4. Validate with `nbformat.validate`, then save with `nbformat.write`.

For a new notebook, use `nbformat.v4.new_notebook` and the cell constructors directly.

## Collaboration and execution

Assume the newest Jupyter Collaboration. Edits within the shared session synchronize automatically. External disk edits can prompt **Open original file**; choose that action to load the disk version into the shared session. Reuse the user's open notebook and kernel. See the [current collaboration documentation](https://jupyterlab-realtime-collaboration.readthedocs.io/en/latest/).

Tell the user which changed cells and dependent cells need rerunning. Execute cells only when requested; use the live kernel when available and disclose any separate-kernel execution.

## Git

Jupytext is optional and used only to export readable script diffs after editing the notebook. Install it if needed and export in one direction:

```bash
jupytext --to py:percent notebook.ipynb
```

Keep automatic Jupytext pairing disabled. Do not use `jupytext --sync` or edit the exported script as the notebook source.
