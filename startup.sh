#!/bin/bash

# Ställ CPU-scaling governor till 'performance' om möjligt
if [ -w /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
  echo "Setting CPU governor to performance..."
  echo "performance" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
else
  echo "CPU governor not writable (may need privileged mode)"
fi

# Copy ARM64-compatible configuration files to data volume (fixes SQLite native library issue)
echo "Copying ARM64-compatible configuration files..."
if [ -f /opt/ignition/config-templates/logback.xml ]; then
  cp /opt/ignition/config-templates/logback.xml /opt/ignition/data/logback.xml
  echo "  - logback.xml copied"
fi

# Ensure ignition.conf has SQLite native library settings
if ! grep -q "org.sqlite.lib.path" /opt/ignition/data/ignition.conf 2>/dev/null; then
  echo "Adding SQLite native library settings to ignition.conf..."
  echo 'wrapper.java.additional.7=-Djava.io.tmpdir=/opt/ignition/temp' >> /opt/ignition/data/ignition.conf
  echo 'wrapper.java.additional.8=-Dorg.sqlite.lib.path=/opt/ignition/native-lib' >> /opt/ignition/data/ignition.conf
  echo 'wrapper.java.additional.9=-Dorg.sqlite.lib.name=libsqlitejdbc.so' >> /opt/ignition/data/ignition.conf
fi

# Starta Ignition i förgrund
echo "Starting Ignition Gateway..."
exec /opt/ignition/ignition.sh console
