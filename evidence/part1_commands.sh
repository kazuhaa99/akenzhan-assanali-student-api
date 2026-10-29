#!/bin/bash
# Part 1 — Linux administration
# Executed as user "akenzhan" inside an Ubuntu 24.04 container (eclipse-temurin:17-jdk).
set -x
cd ~/akenzhan-assanali-student-api

# ---------- Task 1.1 — project structure ----------
mkdir -p scripts logs backups src
touch Dockerfile docker-compose.yml Jenkinsfile build.gradle README.md
touch scripts/Akenzhan_Assanali_system_report.sh
touch logs/Akenzhan_Assanali_system_report.log
tree -L 2 --dirsfirst -I 'build|gradle|evidence|main|test'
for f in scripts logs backups src Dockerfile docker-compose.yml Jenkinsfile build.gradle README.md \
         scripts/Akenzhan_Assanali_system_report.sh logs/Akenzhan_Assanali_system_report.log; do
    [ -e "$f" ] && echo "OK      $f" || echo "MISSING $f"
done

# ---------- Task 1.2 — system monitoring script ----------
cat scripts/Akenzhan_Assanali_system_report.sh
bash scripts/Akenzhan_Assanali_system_report.sh

# ---------- Task 1.3 — permissions and backup ----------
ls -l scripts/Akenzhan_Assanali_system_report.sh
chmod +x scripts/Akenzhan_Assanali_system_report.sh
chmod 744 scripts/Akenzhan_Assanali_system_report.sh      # owner rwx, group r--, others r--
ls -l scripts/Akenzhan_Assanali_system_report.sh
stat -c '%A %a %U %n' scripts/Akenzhan_Assanali_system_report.sh
./scripts/Akenzhan_Assanali_system_report.sh > /dev/null  # now runs directly as an executable

cp README.md backups/README_Akenzhan_Assanali_backup.md
ls -l backups/
diff README.md backups/README_Akenzhan_Assanali_backup.md && echo "Backup has the same contents as README.md"
cat backups/README_Akenzhan_Assanali_backup.md

# ---------- Task 1.4 — process and log analysis ----------
java /tmp/AkenzhanWorker.java &            # start a Java process for the demonstration
sleep 4
ps aux
ps aux | grep -i [j]ava
pgrep -a java
tail -n 5 logs/Akenzhan_Assanali_system_report.log
grep -n "Akenzhan" logs/Akenzhan_Assanali_system_report.log
grep -n "Akenzhan" logs/Akenzhan_Assanali_system_report.log > logs/Akenzhan_Assanali_log_analysis.txt
cat logs/Akenzhan_Assanali_log_analysis.txt
kill $(pgrep -f AkenzhanWorker)
