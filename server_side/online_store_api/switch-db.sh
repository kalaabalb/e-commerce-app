#!/bin/bash

ENV_FILE=".env"
LOCAL_DB="mongodb://127.0.0.1:27017/rapid"
ATLAS_DB="mongodb+srv://yonasmarketplace_db:DnO3zO2TtCRdin1f@market-cluster.zphhv9i.mongodb.net/rapid?retryWrites=true&w=majority"

if [ "$1" = "local" ]; then
    # Remove any existing MONGO_URL line and add the correct one
    grep -v "^MONGO_URL=" "$ENV_FILE" > "$ENV_FILE.tmp"
    echo "MONGO_URL=$LOCAL_DB" >> "$ENV_FILE.tmp"
    mv "$ENV_FILE.tmp" "$ENV_FILE"
    echo "✅ Switched to LOCAL MongoDB (for campus development)"
    
elif [ "$1" = "atlas" ]; then
    # Remove any existing MONGO_URL line and add the correct one
    grep -v "^MONGO_URL=" "$ENV_FILE" > "$ENV_FILE.tmp"
    echo "MONGO_URL=$ATLAS_DB" >> "$ENV_FILE.tmp"
    mv "$ENV_FILE.tmp" "$ENV_FILE"
    echo "✅ Switched to ATLAS MongoDB (for production/testing)"
    
elif [ "$1" = "status" ]; then
    if grep -q "^MONGO_URL=" "$ENV_FILE"; then
        CURRENT_DB=$(grep "^MONGO_URL=" "$ENV_FILE" | cut -d'=' -f2-)
        if [[ "$CURRENT_DB" == *"127.0.0.1"* ]]; then
            echo "📱 Current: LOCAL MongoDB"
        else
            echo "☁️  Current: ATLAS MongoDB"
        fi
    else
        echo "❌ No MONGO_URL found in .env"
    fi
    
else
    echo "Usage: ./switch-db.sh [local|atlas|status]"
    echo "  local  - Use local MongoDB (for campus)"
    echo "  atlas  - Use MongoDB Atlas (when you have good internet)"
    echo "  status - Show current database"
fi
