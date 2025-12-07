# Ignition Edge på Raspberry Pi 5 via Balena

## Deployment Guide

**Version:** Ignition 8.1.50  
**Platform:** Raspberry Pi 5 (ARM64/aarch64)  
**Datum:** 2024-12-06

---

## Snabbstart

cd /home/nikzel/Docker_/Balena/Images/ignition-rpi5
balena deploy <balena*user/<fleet> --build


---

## Viktigt: balena push vs balena deploy

| Kommando              | Fungerar?  | Anledning                          |
|-----------------------|------------|------------------------------------|
| balena push           | ❌ NEJ     | Timeout - projektet är ~2GB        |
| balena deploy --build | ✅ JA      | Bygger lokalt, pushar färdig image |

---

## Katalogstruktur

\\\
ignition-rpi5/
├── Dockerfile
├── docker-compose.yml
├── startup.sh
├── DEPLOYMENT_GUIDE.md
├── Ignition-linux-aarch-64-8.1.50/
└── modules/
    └── MQTT-Engine-signed.modl
\\\

---

## Deployment-steg

### 1. Första gången: Aktivera ARM64-emulering

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes


### 2. Deploya till Balena

cd /path/to/Balena/Images/ignition-rpi5
balena deploy <balena*user/<fleet> --build

---

## Efter deployment

- **Ignition Gateway:** http://<device-ip>:8088
- **Användare:** admin
- **Lösenord:** password (ändra vid första inloggning!)

---

## Balena Dashboard

- **URL:** https://dashboard.balena-cloud.com/apps/xxxxxxx/devices
- **Fleet:** <balena*user/<fleet>

---

## Felsökning

### Timeout vid push
Använd balena deploy --build istället för balena push

### exec format error
Kör: \docker run --rm --privileged multiarch/qemu-user-static --reset -p yes\

### Gammal Balena CLI
Uppdatera: \
pm install -g balena-cli\
