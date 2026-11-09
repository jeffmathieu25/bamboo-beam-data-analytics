"""Execute the repository notebook's analytical cells from Python."""
from pathlib import Path
import os
import json

ROOT = Path(__file__).resolve().parents[1]
os.chdir(ROOT)
os.environ.setdefault("BAMBOO_DATA_DIR", str(ROOT / "data"))
notebook = json.loads((ROOT / "notebooks" / "Bamboo_Beam_Experimental_Analysis.ipynb").read_text(encoding="utf-8"))
namespace = {}
for index, cell in enumerate(notebook["cells"]):
    if cell["cell_type"] == "code":
        exec(compile("".join(cell["source"]), f"notebook_cell_{index}", "exec"), namespace)
