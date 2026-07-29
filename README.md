# 💾 rm dckr

[![Static Badge](https://img.shields.io/badge/Linux-white?style=flat&logo=linux&logoColor=white&logoSize=auto&labelColor=black)](https://www.linux.org/)
[![Static Badge](https://img.shields.io/badge/Docker-white?style=flat&logo=docker&logoColor=white&logoSize=auto&labelColor=black)](https://docker.com/)
[![Static Badge](https://img.shields.io/badge/Bash-Script-white?style=flat&logo=gnubash&logoColor=white&logoSize=auto&labelColor=black)](https://www.gnu.org/software/bash/)
[![Static Badge](https://img.shields.io/badge/GPL-V3-white?style=flat&logo=gnu&logoColor=white&logoSize=auto&labelColor=black)](https://www.gnu.org/licenses/gpl-3.0.en.html/)

rm dckr, is a shell script tool designed to help you clean up Docker resources, making Docker resource management more streamlined and efficient.

## ✨ Features

- Remove all Docker containers
- Remove all Docker images
- Remove all Docker volumes
- Remove all Docker networks
- Simple and intuitive command-line interface
- Safe operation with confirmation prompts

## 🚀 Quick Start

### One-line Install

```bash
curl -fsSL https://raw.githubusercontent.com/peterweissdk-priv/rm_dckr/main/install.sh | bash
```

### Manual Install

1. Clone this repository:
   ```bash
   git clone https://github.com/peterweissdk/rm_dckr.git
   ```

2. Make the script executable:
   ```bash
   chmod +x rm_dckr.sh
   ```

3. Run the script:
   ```bash
   ./rm_dckr.sh
   ```

## 📖 Usage

```bash
rm_dckr [OPTIONS]
```

### Options

| Option | Description |
|--------|-------------|
| `-h, --help` | Display help message |
| `-v, --version` | Display current version |
| `-u, --update` | Update rm_dckr to the latest version |

Without options, the script will interactively prompt to remove Docker resources.

## 📝 Directory Structure

```bash
rm_dckr/
├── .git
├── install.sh
├── LICENSE
├── README.md
└── rm_dckr.sh
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 🆘 Support

If you encounter any issues or need support, please file an issue on the GitHub repository.

## 📄 License

This project is licensed under the GNU GENERAL PUBLIC LICENSE v3.0 - see the [LICENSE](LICENSE) file for details.