### TO-DO
- copy some script and addition from bazzite

# 🎯 Projet : Image Fedora Atomic Sway personnalisée (Desktop AMD)

## 🧩 Objectif
Me basé sur l'**image Fedora Atomic Sway ( Sericea )**, pour faire une image custom, prête a l'emploi ( pour moi ) et fonctionnel
But : un environnement **performant, reproductible**, avec de légére optimisation pour **le gaming**, tout en conservant la nature **immutable** d'une Fedora Atomic.
**Basée :** Fedora Atomic Sway (Sericea)
---

## 🧱 Structure du dépôt
Basé sur le **template uBlue**, avec les éléments principaux :
- `Containerfile` — définition de l’image custom, héritant de `fedora-atomic-sway`
- `build.sh` 

---

## ✅ État actuel

- [x] SELinux actif (set par défaut avec Fedora)
- [X] Liste de logiciel préinstaller
- [X] Gamemode ( dans le futur remplacé par Falcond )
- [X] Sway est configuré, avec waybar, rofi, Icones, Wallpaper
- [X] Configuration par défault Zram modifier

---

## 🚧 Étapes à venir

### 🧠 Optimisations système
- [ ] TO DO
- [x] Zram configuré ( 50% ram, ou maximum 20Gb ) 
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
- [x] Configuration Sway (keybinds, rules)
- [x] Waybar : topbar + modules personnalisés
- [x] rofi configurés ( a méditer pour rofi, j'envisage une autre option - vicinae)
- [ ] Thème GTK/Qt global 
- [x] Pack d’icônes : **[Arashi](https://github.com/0hStormy/Arashi/releases)**
- [x] Wallpaper par défaut intégré

---

---

### 🔒 Hardening additionnel (léger)
- [ ] Vérification journald (rotation, taille, compression)
- [ ] Firewalld : zones et règles affinées
- [ ] Vérification XDG & désactivation autologin

---

## 📘 Information 
- Image de base : Fedora sway Atomic
- point clé : réactif et élégant, légère opti
