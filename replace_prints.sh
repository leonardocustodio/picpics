#!/bin/bash

# First, let's handle the main.dart file
echo "Processing main.dart..."
sed -i '' "s/print('[BackgroundFetch] Headless event received.');/AppLogger.d('[BackgroundFetch] Headless event received.');/g" lib/main.dart
sed -i '' "s/print('Has setted app group: \$setAppGroup');/AppLogger.d('Has setted app group: \$setAppGroup');/g" lib/main.dart
sed -i '' "s/print('Main Build!!!');/AppLogger.d('Main Build!!!');/g" lib/main.dart
sed -i '' "s/print('lang: \${widget.user.appLocale.value}');/AppLogger.d('lang: \${widget.user.appLocale.value}');/g" lib/main.dart
sed -i '' "s/print('&&&& Here lifecycle!');/AppLogger.d('&&&& Here lifecycle!');/g" lib/main.dart
sed -i '' "s/print('&&&&&&&&& App got back from background');/AppLogger.d('&&&&&&&&& App got back from background');/g" lib/main.dart

# Handle UserController logs
echo "Processing UserController..."
sed -i '' "1s/^/import 'package:picPics\/utils\/app_logger.dart';\n/" lib/stores/user_controller.dart 2>/dev/null || true
sed -i '' "s/print('\[UserController\]/AppLogger.i('[UserController]/g" lib/stores/user_controller.dart
sed -i '' "s/print('  /AppLogger.d('  /g" lib/stores/user_controller.dart

# Handle TabsScreen logs
echo "Processing TabsScreen..."
sed -i '' "1s/^/import 'package:picPics\/utils\/app_logger.dart';\n/" lib/screens/tabs_screen.dart 2>/dev/null || true
sed -i '' "s/print('\[TabsScreen\]/AppLogger.i('[TabsScreen]/g" lib/screens/tabs_screen.dart

# Handle other common print statements
echo "Processing other files..."
find lib -name "*.dart" -type f | while read -r file; do
    # Skip if file already has the import
    if ! grep -q "import 'package:picPics/utils/app_logger.dart';" "$file"; then
        # Check if file has print statements
        if grep -q "print(" "$file"; then
            # Add import at the beginning of the file, after the existing imports
            # Find the last import line
            last_import_line=$(grep -n "^import " "$file" | tail -1 | cut -d: -f1)
            if [ -n "$last_import_line" ]; then
                sed -i '' "${last_import_line}a\\
import 'package:picPics/utils/app_logger.dart';
" "$file"
            else
                # If no imports found, add at the beginning
                sed -i '' "1s/^/import 'package:picPics\/utils\/app_logger.dart';\n\n/" "$file"
            fi
        fi
    fi
    
    # Replace print statements
    sed -i '' "s/print(/AppLogger.d(/g" "$file"
done

echo "Replacement complete!"