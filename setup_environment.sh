#!/bin/bash

# Script to setup environment

# Define the YAML file path
YAML_FILE="oar_pbb_env.yml"

# Define the directory where the YAML file is located
YAML_DIR="/Users/daragon/University of Oregon Dropbox/Denicia Aragon/projects/place-based-belonging"  # Replace with the actual path

# Function to check for command existence
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to install Miniconda
install_miniconda() {
  echo "Installing Miniconda..."
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
  else
    echo "Unsupported OS. Please install Miniconda manually."
    exit 1
  fi

  curl -LO $MINICONDA_URL
  bash Miniconda3-latest-*.sh -b -p $HOME/miniconda
  rm Miniconda3-latest-*.sh
  export PATH="$HOME/miniconda/bin:$PATH"
  conda init "$(basename $SHELL)"
}

# Install Miniconda if not already installed
if ! command_exists conda; then
  install_miniconda
else
  echo "Conda is already installed."
fi

# Reload shell to initialize conda
source ~/.bashrc || source ~/.zshrc

# Install Mamba
echo "Installing Mamba..."
conda install -y -c conda-forge mamba

# Navigate to the directory containing the YAML file
cd $YAML_DIR

# Create the environment
echo "Creating the environment..."
mamba env create -f $YAML_FILE

# Activate the environment
echo "Activating the environment..."
conda activate oar_pbb

echo "Environment setup complete."
