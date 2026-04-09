### TO-DO
- meilleurs gestion des logs
- changé quelque régle de sécu ( notamment firewall )
- si test unstable concluant avec falcond, merge branch

# 🎯 Projet : Image Fedora Atomic Sway personnalisée (Desktop AMD)

## 🧩 Objectif
Me baser sur l'**image Fedora Atomic Sway ( Sericea )**, avoir l'os parfait OOTB ( pour moi ) et fonctionnel
tout en conservant un environnement **performant, reproductible**, avec de légére optimisation pour **le gaming**, tout en conservant la nature **immutable** d'une Fedora Atomic.
---

## 🧱 Structure du dépôt
Basé sur le **template uBlue**, avec les éléments principaux :
- `Containerfile` — définition de l’image custom, héritant de `fedora-atomic-sway`
- `build.sh` - Script majeur, il list et install ( avec dnf5 ) les logicielle, compile si besoin, vas cherche un pack d'icone etc
- `systemd-services.sh` - contient l'activation des service systemd néccésaire

---

## ✅ État actuel

- [x] SELinux actif (set par défaut avec Fedora)
- [X] Liste de logiciel préinstaller
- [X] Gamemode ( branche unstable avec Falcond )
- [X] Sway est configuré, ainsi que waybar, rofi, Icones, et un Wallpaper par défault
- [X] Configuration par défault Zram modifier

---

## 🚧 Étapes à venir

### 🧠 Optimisations système
- [ ] TO DO
- [x] Zram configuré ( 50% ram, ou maximum 20Gb, au lieu de 1/4 de la ram dispo ) 
---

### 🎮 Logiciels à intégrer
- [x] Steam ( and usage of NonSteamLauncher, to use Epic,Gog directly in Steam )
- [x] Gamemode
- [x] Discord, Firefox
- [x] Protonplus ( Flatpak ) 
- [ ] Virt-manager / QEMU / libvirt / spice-vdagent (VM)
- [x] Outils : neovim, git, **fastfetch**, btop, etc.

---

### 🖥️ Environnement Sway & UI
- [x] Configuration Sway (keybinds, rules, etc)
- [x] Waybar : topbar + modules personnalisés
- [x] rofi configurés ( a méditer pour rofi, j'envisage une autre option - vicinae)
- [x] Thème GTK3
- [ ] Thème GTK4/Qt global
- [x] Pack d’icônes : **[Arashi](https://github.com/0hStormy/Arashi/releases)**
- [x] Wallpaper par défaut intégré

---

---

### 🔒 Hardening additionnel (léger)
- [ ] Vérification journald (rotation, taille, compression)
- [ ] Firewalld : zones et règles affinées

---

## 📘 Information 
- Image de base : Fedora sway Atomic
- point clé : réactif et élégant, légère opti
