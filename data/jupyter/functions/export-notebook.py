import nbformat
import argparse

# Erstelle einen Argumentparser
parser = argparse.ArgumentParser(description="Extrahiere Codezellen aus einem Jupyter-Notebook außer der letzten und speichere sie in einer Datei.")
parser.add_argument('notebook_path', type=str, help="Pfad zu deinem aktuellen Notebook")
parser.add_argument('output_file', type=str, help="Pfad zur Ausgabedatei")

# Parst die Argumente
args = parser.parse_args()

# Pfad zu deinem aktuellen Notebook
notebook_path = args.notebook_path

# Pfad zur Ausgabedatei
output_file = args.output_file

# Lade das Notebook
with open(notebook_path, 'r', encoding='utf-8') as f:
    notebook = nbformat.read(f, as_version=4)

# Extrahiere den Code aus den Codezellen, außer der letzten
code_cells = [cell['source'] for cell in notebook.cells if cell.cell_type == 'code']

# Schreibe die extrahierten Codes in eine Datei
with open(output_file, 'w', encoding='utf-8') as f:
    for cell in code_cells:
        f.write(cell + '\n\n')

print(f"Codezellen wurden in {output_file} geschrieben")
