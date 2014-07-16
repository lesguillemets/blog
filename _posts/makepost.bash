filename="`date "+%Y-%m-%d-"`$1".md
cp -i ./template.md "$filename"
echo "Created $filename"
