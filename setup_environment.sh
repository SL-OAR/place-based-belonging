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

# Function to check for command existence
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to install Anaconda
install_anaconda() {
  echo "Installing Anaconda..."
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ANACONDA_URL="https://repo.anaconda.com/archive/Anaconda3-latest-Linux-x86_64.sh"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    ANACONDA_URL="https://repo.anaconda.com/archive/Anaconda3-latest-MacOSX-x86_64.sh"
  else
    echo "Unsupported OS. Please install Anaconda manually."
    exit 1
  fi

  curl -LO $ANACONDA_URL
  bash Anaconda3-latest-*.sh -b -p $HOME/anaconda
  rm Anaconda3-latest-*.sh
  export PATH="$HOME/anaconda/bin:$PATH"
  conda init "$(basename $SHELL)"
}

# Install Anaconda if not already installed
if ! command_exists conda; then
  install_anaconda
else
  echo "Conda is already installed."
fi

# Reload shell to initialize conda
source ~/.bashrc || source ~/.zshrc

# Install Mamba
echo "Installing Mamba..."
conda install -y -c conda-forge mamba

# Navigate to the directory containing the YAML file
cd "$YAML_DIR"

# Create the environment
echo "Creating the environment..."
mamba env create -f "$YAML_FILE"

# Activate the environment
echo "Activating the environment..."
conda activate oar_pbb

echo "Environment setup complete."
