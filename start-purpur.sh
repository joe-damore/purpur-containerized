#!/bin/sh

cd /purpur_world || exit 1

if [ ! -f /purpur_world/eula.txt ]; then
    echo "eula=true" >> /purpur_world/eula.txt
    echo "Created 'eula.txt'"
fi

echo "Starting Purpur..."
# Flags are from:
# https://blog.airplane.gg/aikar-flags/
# Retrieved 2022-01-08

# TODO Use env for memory min/max.
java \
    -Xms12G \
    -Xmx12G \
    -XX:+UseG1GC \
    -XX:+ParallelRefProcEnabled \
    -XX:MaxGCPauseMillis=200 \
    -XX:+UnlockExperimentalVMOptions \
    -XX:+DisableExplicitGC \
    -XX:+AlwaysPreTouch \
    -XX:G1HeapWastePercent=5 \
    -XX:G1MixedGCCountTarget=4 \
    -XX:G1MixedGCLiveThresholdPercent=90 \
    -XX:G1RSetUpdatingPauseTimePercent=5 \
    -XX:SurvivorRatio=32 \
    -XX:+PerfDisableSharedMem \
    -XX:MaxTenuringThreshold=1 \
    -XX:G1NewSizePercent=30 \
    -XX:G1MaxNewSizePercent=40 \
    -XX:G1HeapRegionSize=8M \
    -XX:G1ReservePercent=20 \
    -XX:InitiatingHeapOccupancyPercent=15 \
    -Dusing.aikars.flags=https://mcflags.emc.gs \
    -Daikars.new.flags=true \
    -jar '/purpur/purpur.jar' \
    nogui 1>&1 2>&2
wait

exit 0
