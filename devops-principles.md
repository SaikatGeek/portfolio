# 🚀 World-Class DevOps / Platform Engineering — মূল প্রিন্সিপল নোট

> এই নোটটা আমার রেফারেন্স। প্রতিটা সিদ্ধান্ত নেওয়ার আগে এই প্রিন্সিপলগুলো মাথায় রাখব।

---

## ১. Principle of Least Privilege (সর্বনিম্ন অনুমতির নীতি)

প্রতিটা user, process, বা service-কে শুধু ততটুকুই permission দাও যতটুকু তার কাজ করতে দরকার — এর বেশি একদমই না।

- কখনো `root` দিয়ে app চালাবে না
- CI/CD-এর জন্য আলাদা `deployer` user বানাবে
- প্রতিটা service-এর জন্য আলাদা user (যেমন `www-data`, `appuser`)

**কেন:** যদি কিছু hack হয় বা ভুল হয়, ক্ষতির পরিমাণ (blast radius) ছোট থাকবে।

---

## ২. Blast Radius চিন্তা করো

যেকোনো সিদ্ধান্ত নেওয়ার আগে নিজেকে জিজ্ঞেস করো:
> "যদি এইটা fail করে বা hack হয়, সবচেয়ে খারাপ কী হতে পারে?"

ভালো ইঞ্জিনিয়াররা ধরেই নেয় যে **ভুল হবেই, secret leak হবেই** — তাই সিস্টেম এমনভাবে বানায় যাতে ক্ষতি কম আর recover করা সহজ হয়।

---

## ৩. Automate Everything (সবকিছু অটোমেট করো)

হাতে করে server-এ গিয়ে কমান্ড চালানো = ভুলের সম্ভাবনা + সময় নষ্ট।

- Deployment → CI/CD pipeline দিয়ে অটোমেট করো
- Server setup → script বা Infrastructure as Code দিয়ে
- যদি একই কাজ ২ বার করো, সেটা অটোমেট করার কথা ভাবো

**মনে রাখবে:** "If you do it twice, automate it."

---

## ৪. Infrastructure as Code (IaC)

Server, network, সবকিছুর কনফিগ কোড আকারে রাখো (Terraform, Ansible দিয়ে)।

- হাতে UI ক্লিক করে server বানিও না — code লিখো
- কোড version control (Git)-এ থাকবে
- নতুন server লাগলে এক কমান্ডে আবার বানাতে পারবে

**সুবিধা:** reproducible, review করা যায়, ভুল হলে rollback করা যায়।

---

## ৫. Secrets কখনো কোডে রাখবে না

Password, API key, SSH key — এগুলো কখনো সরাসরি কোডে বা GitHub-এ commit করবে না।

- GitHub Secrets, Vault, বা environment variable ব্যবহার করো
- `.env` ফাইল সবসময় `.gitignore`-এ রাখো
- Secret leak হলে সাথে সাথে rotate (পরিবর্তন) করো

---

## ৬. Version Control সব কিছুর জন্য (Git)

কোড, কনফিগ, ডকুমেন্টেশন — সব Git-এ রাখো।

- ছোট ছোট, পরিষ্কার commit করো
- ভালো commit message লেখো (`fix:`, `feat:`, `refactor:`)
- কখনো সরাসরি production-এ কোড change করবে না — সবসময় Git হয়ে যাবে

---

## ৭. Immutable Infrastructure (অপরিবর্তনীয় অবকাঠামো)

Server-কে "pet" না ভেবে "cattle" ভাবো।

- চলমান server-এ হাতে হাতে পরিবর্তন করবে না
- পরিবর্তন দরকার হলে → নতুন version বানাও, পুরোনোটা ফেলে দাও
- এতে সব server একই থাকে, "এই server-এ কাজ করে কিন্তু ওটায় করে না" সমস্যা হয় না

---

## ৮. Monitoring & Observability (পর্যবেক্ষণ)

যা measure করতে পারো না, তা improve করতে পারো না।

- **Logs** — কী হচ্ছে তা লেখা থাকে
- **Metrics** — CPU, RAM, request count ইত্যাদি সংখ্যা
- **Alerts** — সমস্যা হলে যেন তুমি সাথে সাথে জানো
- ব্যবহারকারী সমস্যা report করার *আগেই* তুমি যেন জানো

---

## ৯. Fail Fast, Recover Faster (দ্রুত রিকভারি)

ভুল হবেই — গুরুত্বপূর্ণ হলো কত দ্রুত ঠিক করতে পারো।

- **Backup** নিয়মিত রাখো এবং restore টেস্ট করো
- **Rollback** plan রাখো — খারাপ deploy দ্রুত আগের version-এ ফেরাতে পারো
- একটা service down হলে যেন পুরো সিস্টেম down না হয়

---

## ১০. Security by Default (নিরাপত্তা প্রথম থেকেই)

নিরাপত্তা পরে যোগ করার জিনিস না — শুরু থেকেই রাখতে হয়।

- SSH-এ password নয়, **SSH key** ব্যবহার করো
- Firewall configure করো (শুধু দরকারি port খোলা রাখো — 22, 80, 443)
- নিয়মিত system update করো
- Root login সরাসরি বন্ধ রাখো (`PermitRootLogin no`)
- Fail2ban দিয়ে brute-force আক্রমণ ঠেকাও

---

## ১১. Documentation (ডকুমেন্টেশন)

ভবিষ্যতের "তুমি" আজকের "তুমি"-কে ধন্যবাদ দেবে।

- README লেখো — কীভাবে setup/deploy করতে হয়
- কেন একটা সিদ্ধান্ত নিয়েছ তা লিখে রাখো
- যা একবার করেছ, আবার করতে হলে যেন reference থাকে

---

## ১২. Keep It Simple (সরল রাখো — KISS)

সবচেয়ে ভালো সিস্টেম সবচেয়ে জটিল না, সবচেয়ে **সহজ যেটা কাজ করে**।

- শুরুতে over-engineer করবে না
- যখন সত্যিই দরকার হবে তখনই জটিলতা যোগ করবে
- "Boring technology" ভালো — proven, stable জিনিস ব্যবহার করো

---

## 🎯 মূল মন্ত্র (Golden Rules)

1. **ধরে নাও ভুল হবে** — সেভাবে সিস্টেম বানাও
2. **ধরে নাও secret leak হবে** — least privilege রাখো
3. **হাতে যা করছ, সেটা অটোমেট করার কথা ভাবো**
4. **সবকিছু Git-এ রাখো**
5. **পরিমাপ করো, তারপর উন্নত করো**

---

## 📚 শেখার রোডম্যাপ (পরবর্তী ধাপ)

- [ ] Linux basics ও command line ভালো করে শেখা
- [ ] Git ও GitHub ভালোভাবে রপ্ত করা
- [ ] CI/CD (GitHub Actions) — *এখন এটাই শিখছি* ✅
- [ ] Docker (containerization)
- [ ] Nginx / reverse proxy
- [ ] Infrastructure as Code (Terraform / Ansible)
- [ ] Monitoring (Prometheus, Grafana)
- [ ] Cloud basics (AWS / DigitalOcean / GCP)
- [ ] Kubernetes (যখন বড় scale লাগবে)

---

> 💡 **মনে রাখবে:** সেরা DevOps ইঞ্জিনিয়াররা টুল মুখস্থ করে না — তারা **প্রিন্সিপল** বোঝে। টুল বদলায়, প্রিন্সিপল থাকে।
