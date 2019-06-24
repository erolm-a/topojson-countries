#!/bin/bash

STATES_FILE="../map_sovereignity/ne_10m_admin_0_sovereignty.shp"
PLACES_FILE="../map_places/ne_10m_populated_places.shp"

for i in "$@"
do
    SOVER_FILE="$i-sover.json"
    PLACE_FILE="$i-places.json"

    ogr2ogr \
        -f GeoJSON \
        -where "ADMIN = '$i'" \
        "$SOVER_FILE" \
        $STATES_FILE

    ogr2ogr \
        -f GeoJSON \
        -where "adm0name = '$i' AND scalerank < 5" \
        "$PLACE_FILE" \
        $PLACES_FILE

    topojson \
        -o "$i.json" \
        --id-property SU_A3 \
        --properties name=NAME \
        -- \
        "$SOVER_FILE" \
        "$PLACE_FILE"

    rm "$SOVER_FILE" "$PLACE_FILE"
done

