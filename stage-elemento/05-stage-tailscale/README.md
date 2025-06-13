# Stage Tailscale - Firstboot Setup

Questo stage installa e configura **Tailscale** su Raspberry Pi (DuetPi / pi-gen fork).  
Include uno script di setup interattivo al primo boot.

## Flusso compatibile pi-gen / DuetPi

- 00-run.sh → aggiunge repo + installa `tailscale`
- 01-run.sh → copia i file nella rootfs target
- 01-run-chroot.sh → abilita i servizi con `ln -sf` (compatibile chroot)
- Il firstboot-tailscale.sh fa login automatico o interattivo

## Uso di /boot/tailscale.authkey

Vedi README completo nei precedenti zip.

---

Versione finale compatibile chroot-friendly 🚀
