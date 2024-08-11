import nbformat
import sys
import argparse

def notebook_to_markdown(notebook_path, output_path):
    # Laden des Jupyter Notebooks
    with open(notebook_path, 'r', encoding='utf-8') as f:
        nb = nbformat.read(f, as_version=4)
    
    markdown_output = []
    
    for cell in nb.cells:
        if cell.cell_type == 'markdown':
            markdown_output.append(cell.source)
        elif cell.cell_type == 'code':
            code_lines = cell.source.splitlines()
            formatted_code_lines = []

            for line in code_lines:
                # Entferne %%bash und !, rücke dann die Zeilen um 4 Leerzeichen ein
                if line.startswith('%%bash'):
                    line = line[len('%%bash'):].strip()
                elif line.strip().startswith('!'):
                    line = line.lstrip('!')
                formatted_code_lines.append("    " + line)
            
            markdown_output.append("\n".join(formatted_code_lines))
    
    # Markdown in die Ausgabedatei schreiben
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write("\n\n".join(markdown_output))

def main():
    parser = argparse.ArgumentParser(description="Convert a Jupyter Notebook to a Markdown file.")
    parser.add_argument("notebook_path", help="Path to the Jupyter Notebook (.ipynb file).")
    parser.add_argument("output_path", help="Path to the output Markdown file (.md).")

    args = parser.parse_args()

    notebook_to_markdown(args.notebook_path, args.output_path)

if __name__ == "__main__":
    main()
