#!/bin/bash


sed -i 's|"vue-material": "^1.0.0-beta-7"|"vue-material": "1.0.0-beta-11"|g' package.json

echo "Versión de vue-material actualizada a 1.0.0-beta-11"