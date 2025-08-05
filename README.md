# **Advanced Port Scanner Tool - Description**  

**Author:** Hemil Pnachal  
**Version:** 3.0  
**Purpose:** Comprehensive **Network Scanning & Information Gathering**  

---

## **🔹 Key Features**  

### **1. Port Scanning Techniques**  
- **Quick Port Scan** – Fast scan of common ports  
- **Full Port Scan** – Scans all 65,535 ports  
- **Custom Port Range** – Scan specific ports (e.g., `20-80`)  
- **TCP Scan** – Traditional TCP connection scan  
- **UDP Scan** – Checks for open UDP ports  
- **Top Ports Scan** – Scans most frequently used ports  

### **2. Service & Vulnerability Detection**  
- **Service Detection** – Identifies running services (HTTP, FTP, SSH, etc.)  
- **Vulnerability Scan** – Checks for known vulnerabilities using Nmap scripts  
- **OS Detection** – Detects operating system and version  

### **3. Web Application Testing**  
- **HTTP/HTTPS Methods Check** – Tests allowed methods (`GET`, `POST`, `PUT`, etc.)  
- **SSL Certificate Info** – Checks expiry, issuer, cipher suites, and vulnerabilities  
- **Web Server Enumeration** – Identifies web technologies (Apache, Nginx, IIS)  

### **4. Network & Host Discovery**  
- **Ping Scan** – Checks live hosts in a network  
- **Firewall Detection** – Identifies firewall configurations  
- **MAC Spoofing** – Spoofs MAC address (Cisco, Apple, Samsung, etc.)  

### **5. Advanced Reconnaissance**  
- **NSE Script Scanning** – Runs custom Nmap scripts (vuln, exploit, brute-force)  
- **Full Target Information** – Provides:  
  - **WHOIS Lookup** (Domain ownership)  
  - **DNS Enumeration** (Subdomains, MX records)  
  - **Geolocation** (Country, ISP, ASN)  
  - **Traceroute** (Network path analysis)  

---

## **🔹 Why Use This Tool?**  
✅ **All-in-One Scanner** – Combines **Nmap, OpenSSL, WHOIS, DNSenum, and CURL**  
✅ **User-Friendly** – Simple menu-driven interface  
✅ **Comprehensive Recon** – Gathers **IP, ports, services, vulnerabilities, and web app security**  
✅ **Ethical Hacking & Penetration Testing** – Useful for **security audits, bug bounty, and network analysis**  

---

## **🔹 Usage Examples**  
1. **Quick Scan:** `nmap -T4 -F target.com`  
2. **Full Vulnerability Scan:** `nmap --script vuln target.com`  
3. **Check HTTP Methods:** Tests `GET, POST, PUT, DELETE` on a web server  
4. **SSL Check:** `openssl s_client -connect target.com:443`  
5. **MAC Spoofing:** `nmap --spoof-mac Cisco target.com`  

---

### **📌 Note:**  
⚠ **Use responsibly!** Only scan networks you have permission to test.  
⚠ Some scans (like aggressive scans) may trigger **firewalls/IDS**.  

---

## **🚀 How to Run?**  
```bash
chmod +x port_scanner.sh
./port_scanner.sh
```
**Dependencies:** `nmap, openssl, curl, whois, dnsenum` (Auto-install option included)  

---

### **🔐 Perfect For:**  
✔ **Penetration Testers**  
✔ **Bug Bounty Hunters**  
✔ **Network Administrators**  
✔ **Cybersecurity Students**  

This tool **automates complex scanning tasks** into a **single, easy-to-use script** for **faster security assessments**! 🚀
