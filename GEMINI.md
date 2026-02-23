# Project Overview: YWT_ENV - Personal Development Environment Configuration

This repository, `YWT_ENV`, serves as a comprehensive collection of personal development environment configurations, dotfiles, and setup scripts. Its primary purpose is to enable rapid and consistent setup of a customized Linux development environment across different machines, focusing on system settings, Vim, Docker-based development, and backup solutions.

## Key Components and Directories:

-   **`SystemSettings_YWT/`**: Contains scripts and configuration files for setting up core system-wide preferences.
    -   **`install_sys_settings.sh`**: The main script for installing necessary packages, configuring Zsh (with Oh My Zsh and plugins), setting up GNOME Terminal profiles (like `YWT_Dracula`), deploying dotfiles (`.zshrc`, `.bashrc`, `.profile`, `.tmux.conf`), configuring Tmux with TPM, and updating the `/etc/hosts` file. It supports conditional installation of GNOME-related tools and handles Git cloning of plugins.
    -   Includes configurations for `.bashrc`, `.profile`, `.tmux.conf`, and `.zshrc`.
    -   `tmux_scripts/` provides custom Tmux scripts (e.g., `aws_q_popup.sh`, `gemini_popup.sh`, `py_res_popup.sh`).

-   **`VimSettings_YWT/`**: Houses a detailed Vim configuration (`.vimrc`) and associated plugins.
    -   **.vimrc**: A highly customized Vim configuration covering general settings, programming-specific features (Python omnicompletion, auto-formatting with `black` and `isort`), plugin management via `vim-plug`, and integration with various language-server protocol (LSP) and linting tools (ALE, `pylsp`, `flake8`). It also defines custom keybindings and visual settings (Dracula colorscheme, airline status line).
    -   Includes scripts for installing `cscope`, `ctags`, and `nodejs`.
    -   `lint_config/` contains linting configuration files (`.flake8`, `.pylintrc`).

-   **`DockerSettings_YWT/`**: Contains Dockerfiles and associated scripts for building custom development environment images.
    -   **Custom Images**: Provides Docker setups for various tools and frameworks, including:
        -   `tensorflow:latest-gpu-jupyterlab`
        -   `pytorch:latest-gpu-jupyterlab`
        -   `opencv:4.2.0`
        -   `opencv:4.2.0-dlib-face_rec-cuda`
        -   `flask_YWT:dev-server`
        -   `jupyterlab`
        -   `rstudio:dev-server`
    -   Each Docker subdirectory often includes `Dockerfile` and convenience scripts (e.g., `docker_jupyter`, `docker_flask`) for running containers with specific configurations, port mappings, and volume mounts.

-   **`BackupScript/`**: Contains `rclone` based scripts for data synchronization and backup.
    -   `rclone_check`: For checking differences between source and destination.
    -   `rclone_remote_sync`: For syncing local data to a remote drive.

-   **`sync_to_public.sh`**: A utility script used to create a "public" version of this repository (`YWT_ENV_PUBLIC`) by copying its contents and selectively removing sensitive or environment-specific files (e.g., `jupyter_lab_config.py` files, `/etc/hosts`) that should not be shared or are specific to a local setup.

-   **`.specify/`**: This directory suggests the use of the Gemini CLI's `.specify` command or a similar structured approach for defining and documenting features and tasks within this environment.
    -   `templates/spec-template.md`: A template for feature specifications, outlining user scenarios, acceptance criteria, and requirements.

## Intended Usage:

The primary use case for `YWT_ENV` is to:

1.  **Initialize a New Development Machine**: By cloning this repository and executing the relevant `install_sys_settings.sh` and Vim setup scripts, a new system can be quickly configured with the user's preferred development environment.
2.  **Maintain Consistent Configurations**: Ensure that system settings, Vim setup, and Docker environments remain consistent across multiple machines or after reinstallation.
3.  **Rapid Docker Environment Deployment**: Spin up pre-configured Docker containers for specific development tasks (e.g., machine learning with TensorFlow/PyTorch, computer vision with OpenCV, web development with Flask).
4.  **Data Backup and Synchronization**: Utilize the `rclone` scripts for managing data backups to remote storage.
5.  **Structured Development Planning**: Leverage the `.specify` templates for defining and tracking features or tasks related to the environment's evolution.

## Conventions and Important Notes:

-   **Modularity**: Configurations are organized into distinct directories (`SystemSettings_YWT`, `VimSettings_YWT`, etc.) for clarity and ease of management.
-   **Script-driven Setup**: Most setup processes are automated via shell scripts, promoting reproducibility.
-   **Public/Private Separation**: The `sync_to_public.sh` script indicates a clear intention to manage both private and public versions of the configurations, likely to exclude sensitive information from public repositories.
-   **Extensive Vim Configuration**: The `.vimrc` shows a highly personalized and feature-rich Vim setup, integrating modern development tools like LSP and linters.
-   **Docker for Isolated Environments**: Extensive use of Docker for creating isolated and reproducible development environments for various technical stacks.