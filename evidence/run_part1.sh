#!/bin/bash
# Runs Part 1 in a clean Ubuntu container as a regular user and copies the results back.
set -e
apt-get update -qq >/dev/null && apt-get install -y -qq tree procps >/dev/null 2>&1
useradd -m -s /bin/bash akenzhan
P=/home/akenzhan/akenzhan-assanali-student-api
mkdir "$P"
cd /project
cp -r scripts src Dockerfile docker-compose.yml Jenkinsfile build.gradle README.md "$P/"
cat > /tmp/AkenzhanWorker.java <<'J'
public class AkenzhanWorker {
    public static void main(String[] args) throws Exception {
        System.out.println("Java worker of Akenzhan Assanali started");
        Thread.sleep(600_000);
    }
}
J
chown -R akenzhan:akenzhan /home/akenzhan /tmp/AkenzhanWorker.java
su - akenzhan -c "PATH=/opt/java/openjdk/bin:$PATH bash /project/evidence/part1_commands.sh" 2>&1
cp "$P/logs/Akenzhan_Assanali_system_report.log" "$P/logs/Akenzhan_Assanali_log_analysis.txt" /project/logs/
cp "$P/backups/README_Akenzhan_Assanali_backup.md" /project/backups/
