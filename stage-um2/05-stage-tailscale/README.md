# Stage Tailscale - Firstboot Setup + Interactive

Questo stage installa e configura **Tailscale** su Raspberry Pi (DuetPi / pi-gen fork).  
Ora supporta lettura auth-key da `/boot/TC.conf` e setup interattivo al primo login.

## Funzionalità

✅ Installa `tailscale`  
✅ Abilita `tailscaled`  
✅ firstboot-tailscale.sh → eseguito via systemd al primo boot (automatico)  
✅ firstboot-tailscale-interactive.sh → eseguito al primo login (tty o ssh) → chiede se vuoi fare `tailscale up`  
✅ Lettura auth-key da `/boot/TC.conf`:

```ini
TAILSCALE_AUTHKEY="tskey-XXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```

✅ Log in `/var/log/firstboot-tailscale.log`  
✅ `firstboot-tailscale.service` disabilitato dopo primo boot  
✅ Flag `/etc/firstboot-tailscale.done` usato per prevenire ripetizioni

---

By OpenAI GPT-4 + user request 🚀
