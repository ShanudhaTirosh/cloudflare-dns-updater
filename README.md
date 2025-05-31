# Cloudflare DDNS Script (Per PC)
<img alt="License" src="https://img.shields.io/badge/license-MIT-black"> <img alt="Platform" src="https://img.shields.io/badge/platform-Linux%2FmacOS-orange">

This simple BASH script automatically updates a specific A record on Cloudflare with the **public IP** of the PC it runs on. It's ideal for **home labs** or **remote access** setups with dynamic IPs.

Designed for **per-PC deployment** — just copy the script to each machine and change the `record_name` and `sitename`.

---

## 🔧 Setup

1. **Copy the script to each PC** (e.g., `cloudflare-ddns.sh`)
2. Open the script and update these lines:
   ```bash
   record_name="nas.yourdomain.com"  # ← Your subdomain here
   sitename="NAS"                    # ← Just a label for logs

3. Make the script executable:

chmod +x cloudflare-ddns.sh


4. Run it manually or schedule with cron.




---

🕒 Schedule via Crontab

Run every 5 minutes to keep the IP current:

*/5 * * * * /path/to/cloudflare-ddns.sh >> /var/log/ddns.log 2>&1


---

🌐 Cloudflare Requirements

You need:

A Cloudflare account

Your domain added to Cloudflare

A Zone ID (from Cloudflare dashboard)

An API Token with DNS edit permission (recommended)



---

🧪 Tested On

Ubuntu 22.04

Debian 11

Alpine Linux

Raspberry Pi OS



---

🙌 Contribution

Pull requests welcome! Feel free to fork and improve the script or submit bug reports.


---

📄 License

This project is licensed under the MIT License.

---

