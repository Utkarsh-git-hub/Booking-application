
set -e

flutter build web --release --dart-define=API_BASE_URL=$API_BASE_URL
