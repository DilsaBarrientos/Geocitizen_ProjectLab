#!/bin/bash

# Define the target file
POM_FILE="pom.xml"

# Check if the file exists
if [[ ! -f "$POM_FILE" ]]; then
    echo "Error: $POM_FILE not found!"
    exit 1
fi

# Replace all http:// with https:// in the pom.xml file
sed -i 's|http://|https://|g' "$POM_FILE"

# Add version 3.4.0 to maven-war-plugin if it doesn't exist
if ! grep -q '<version>3.4.0</version>' "$POM_FILE" && grep -q '<artifactId>maven-war-plugin</artifactId>' "$POM_FILE"; then
    # Using awk to insert the version tag after the artifactId
    awk '/<artifactId>maven-war-plugin<\/artifactId>/ && !version_added {
        print $0
        print "                <version>3.4.0</version>"
        version_added = 1
        next
    } 1' "$POM_FILE" > temp_pom.xml && mv temp_pom.xml "$POM_FILE"
    
    echo "Added version 3.4.0 to maven-war-plugin in $POM_FILE"
fi

echo "Updated $POM_FILE:"
echo "1. All HTTP URLs changed to HTTPS"
echo "2. Added version 3.4.0 to maven-war-plugin if it wasn't present"