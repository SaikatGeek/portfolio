# DigitalOcean Droplet Setup — Personal Site Hosting

## Server Info
| বিষয় | তথ্য |
|---|---|
| **Provider** | DigitalOcean |
| **Public IP** | 168.144.108.126 |
| **OS** | Ubuntu |
| **Cost** | $9.60/month |
| **SSH Command** | `ssh root@168.144.108.126` |

---

## Step 1 — Server আপডেট

```bash
apt update && apt upgrade -y
```

> নতুন kernel install হলে reboot দিতে হবে:
> ```bash
> reboot
> ```
> ৩০-৬০ সেকেন্ড পর আবার SSH করুন।

---

## Step 2 — Nginx ও Git Install

```bash
apt install nginx git -y
```

- **Nginx** → Web server (browser request handle করে)
- **Git** → GitHub থেকে code নামায়

---

## Step 3 — Site Folder তৈরি

```bash
mkdir -p /var/www/myportfolio
```

> একাধিক সাইটের জন্য আলাদা আলাদা ফোল্ডার:
> ```
> /var/www/
> ├── myportfolio/
> ├── site2/
> └── site3/
> ```

---

## Step 4 — GitHub থেকে Code Clone

```bash
cd /var/www/myportfolio
git clone https://github.com/username/repo-name .
```

> ⚠️ শেষে `.` দিতে ভুলবেন না!

---

## Step 5 — Nginx Config তৈরি

```bash
nano /etc/nginx/sites-available/myportfolio
```

নিচের কোড paste করুন:

```nginx
server {
    listen 80;
    server_name 168.144.108.126;
    root /var/www/myportfolio;
    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

> Save করুন: **Ctrl+X** → **Y** → **Enter**

---

## Step 6 — Config Enable করুন

```bash
# Enable করুন
ln -s /etc/nginx/sites-available/myportfolio /etc/nginx/sites-enabled/

# Default config disable করুন
rm /etc/nginx/sites-enabled/default

# Test করুন
nginx -t

# Reload করুন
systemctl reload nginx
```

> `nginx -t` তে দেখাবে:
> ```
> syntax is ok
> test is successful
> ```

---

## Step 7 — Browser এ Check করুন
http://168.144.108.126

---

## নতুন সাইট যোগ করার Quick Steps

```bash
# ১. ফোল্ডার বানান
mkdir -p /var/www/newsite

# ২. Code নামান
cd /var/www/newsite
git clone https://github.com/username/newrepo .

# ৩. Config বানান
nano /etc/nginx/sites-available/newsite

# ৪. Enable করুন
ln -s /etc/nginx/sites-available/newsite /etc/nginx/sites-enabled/

# ৫. Reload করুন
systemctl reload nginx
```

---

## পরের কাজ (TODO)

- [ ] ডোমেইন কানেক্ট করা (DNS A Record → 168.144.108.126)
- [ ] SSL/HTTPS লাগানো (Certbot দিয়ে)
- [ ] Firewall setup (UFW)

---

## Key Concepts

| বিষয় | কাজ |
|---|---|
| `/var/www/` | সব সাইটের ফাইল এখানে থাকে |
| `/etc/nginx/sites-available/` | Config লেখার জায়গা |
| `/etc/nginx/sites-enabled/` | Active/চালু config |
| `nginx -t` | Config test করা |
| `systemctl reload nginx` | Nginx কে নতুন config জানানো |