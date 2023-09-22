file="Scripts/unused.rb"

if [ -f "$file" ]
then
  echo "$file found."
  ruby $file xcode
else
  echo "warning: $file doesn't exist"
fi
