import argparse

# Erstelle einen Argumentparser
parser = argparse.ArgumentParser(description="Erzeuge ein Dockerfile basierend auf einem Template.")
parser.add_argument('service_name', type=str, help="Name des zu startenden Service-Skripts (z.B. catalog_service.py)")

# Parst die Argumente
args = parser.parse_args()

# Template für das Dockerfile
dockerfile_template = f"""
# Dockerfile for {args.service_name}

# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install Flask setproctitle prometheus_client

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable
ENV NAME {args.service_name}

USER 1001:100

# Run {args.service_name} when the container launches
CMD ["python", "{args.service_name}.py"]
"""

# Pfad zur Ausgabedatei
output_file = "Dockerfile"

# Schreibe das Dockerfile
with open(output_file, 'w', encoding='utf-8') as f:
    f.write(dockerfile_template)

print(f"Dockerfile wurde erfolgreich erstellt und in {output_file} geschrieben.")
